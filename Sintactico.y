%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <conio.h>
	#include <string.h>
	#include "y.tab.h"

	/* Tipos de datos para la tabla de simbolos */
	#define sinTipo 0
  	#define Int 1
	#define Float 2
	#define String 3
	#define CteInt 4
	#define CteFloat 5
	#define CteString 6

	#define TAMANIO_TABLA 256
	#define TAM_NOMBRE 32
	#define MAX_ANIDAMIENTOS 10

	/* Constantes para tercetos */
	#define OFFSET TAMANIO_TABLA
	#define MAX_TERCETOS 512

	#define NOOP -1 /* Sin operador */
	#define BLOQ 7 /* Operador que indica el orden de las sentencias */
	#define CMP 21 /* Comparador de assembler */
	#define BNE 2 /* = */
	#define BGE 4 /* < */
	#define BLT 6 /* >= */
	#define BLE 10 /* > */
	#define BEQ 14 /* != */
	#define BGT 8 /* <= */

	#define OP1 2
	#define OP2 3
	#define OPERADOR 1

	/* Funciones necesarias */
	int yyerror(char* mensaje);
	int yyerror();
	int yylex();

	void agregarVarATabla(char* nombre);
	void agregarTiposDatosATabla(void);
	int agregarCteStringATabla(char* nombre);
	int agregarCteIntATabla(int valor);
	int agregarCteFloatATabla(float valor);

	int chequearVarEnTabla(char* nombre);
	int buscarEnTabla(char * name);
	void escribirNombreEnTabla(char* nombre, int pos);
	void guardarTabla(void);

	void chequearTipoDato(int tipo);
	void resetTipoDato();

	int crear_terceto(int operador, int op1, int op2);
	void guardarTercetos();
	void modificarTerceto(int indice, int posicion, int valor);

	void apilar_xplogic(int indice);
	int desapilar_xplogic();
	int saltarFalse(int comp);

	int yystopparser=0;
	FILE  *yyin;

	/* Cosas de tabla de simbolos */
	typedef struct {
		char nombre[TAM_NOMBRE];
		int tipo_dato;
		char valor_s[TAM_NOMBRE];
		float valor_f;
		int valor_i;
		int longitud;
	} simbolo;

	simbolo tabla_simbolo[TAMANIO_TABLA];
	int fin_tabla = -1; /* Apunta al ultimo registro en la tabla de simbolos. Incrementarlo para guardar el siguiente. */

	/* Cosas para la declaracion de variables y la tabla de simbolos */
	int varADeclarar1 = 0;
	int cantVarsADeclarar = 0;
	int tipoDatoADeclarar;

	/* Cosas para las asignaciones */
	char idAsignar[TAM_NOMBRE];
	/* Cosas para comparadores booleanos */
	int comp_bool_actual;
	/* Cosas para control de tipo de datos en expresiones aritméticas */
	int tipoDatoActual = sinTipo;
	/* Cosas para average */
	int cant;

	/* Cosas para tercetos */
	typedef struct{
		int operador;
		int op1;
		int op2;
	} terceto;
	terceto lista_terceto[MAX_TERCETOS];
	int ultimo_terceto = -1; /* Apunta al ultimo terceto escrito. Incrementarlo para guardar el siguiente. */

	int pila_ind_xplogic[MAX_ANIDAMIENTOS];
	int ultimo_pila_ind_xplogic=-1;
	int ind_branch_pendiente;

	int ind_program;
	int ind_sdec;
	int ind_bdec;
	int ind_dec;
	int ind_tdato;
	int ind_list_id;
	int ind_bloque;
	int ind_sent;
	int ind_bif;
	int ind_bwhile;
	int ind_btrue;
	int ind_asig;
	int ind_xp;
	int ind_xpcad;
	int ind_expr; //Expresion aritmetica
	int ind_rterm;
	int ind_term;
	int ind_pre;
	int ind_factor;
	int ind_xplogic;
	int ind_tlogic;
	int ind_tlogic_izq;
	int ind_expr_izq;
	int ind_compbool;
	int ind_avg;
	int ind_inlist;
	int ind_lec; //Lista expresion coma
	int ind_lepc; //Lista expresion punto y coma
	int ind_lectura;
	int ind_escritura;
%}

%union {
	int int_val;
	float float_val;
	char *string_val;
}

%token START
%token END

%token DECVAR ENDDEC
%token INT FLOAT STRING

%token WHILE ENDWHILE
%token IF THEN ELSE ENDIF

%token AND OR NOT

%token ASIG
%left MAS MENOS
%token POR DIVIDIDO

%token MENOR  MAYOR MENOR_IGUAL MAYOR_IGUAL
%token IGUAL DISTINTO

%token PA PC
%token CA CC
%token COMA
%token PUNTO_COMA

%token READ
%token WRITE
%token AVG
%token INLIST

%token <string_val>ID
%token <float_val>CTE_FLOAT
%token <int_val>CTE_INT
%token <string_val>CTE_STRING

%%

programa:
	START seccion_declaracion bloque END 	            {
															printf("\nCOMPILACION EXITOSA\n");
															guardarTabla();

															ind_program = crear_terceto(START, ind_sdec, ind_bloque);
															guardarTercetos();
														};
/*
programa:
	START bloque END									{
															printf("\nCOMPILACION EXITOSA\n");
															guardarTabla();

															ind_program = crear_terceto(START, NOOP, ind_bloque);
														}
*/
/* Declaracion de variables */

seccion_declaracion:
	DECVAR bloque_dec ENDDEC 				            {
															printf("Regla 1: Seccion declaracion es DECVAR bloque_dec ENDEC\n\n");
														};

bloque_dec:
	bloque_dec declaracion					            {printf("Regla 2: bloque_dec es bloque_dec declaracion\n");}
	| declaracion							            {printf("Regla 3: bloque_dec es declaracion\n");};

declaracion:
	t_dato lista_id PUNTO_COMA				            {
															printf("Regla 4: declaracion es t_dato lista_id PUNTO_COMA\n");
															 agregarTiposDatosATabla();
														};

t_dato:
	FLOAT		                                        {
															printf("Regla 5: t_dato es FLOAT\n");
															tipoDatoADeclarar = Float;
														}
	| INT		                                        {
															printf("Regla 6: t_dato es INT\n");
															tipoDatoADeclarar = Int;
														}
	| STRING	                                        {
															printf("Regla 7: t_dato es STRING\n");
															tipoDatoADeclarar = String;
														};

lista_id:
	lista_id COMA ID	                                {
	                                                        printf("Regla 8: lista_id es lista_id COMA ID(%s)\n", $3);
	                                                        agregarVarATabla(yylval.string_val);
															cantVarsADeclarar++;
                                                        }
	| ID				                                {
	                                                        printf("Regla 9: lista_id es ID(%s)\n", $1);
	                                                        agregarVarATabla(yylval.string_val);
															varADeclarar1 = fin_tabla; /* Guardo posicion de primer variable de esta lista de declaracion. */
															cantVarsADeclarar = 1;
                                                        };

 /* Fin de Declaracion de variables */

 /* Seccion de codigo */

bloque:                                                 /* No existen bloques sin sentencias */
	bloque sentencia	                                {
															printf("Regla 10: bloque es bloque sentencia\n");
															ind_bloque = crear_terceto(BLOQ, ind_bloque, ind_sent);
														}
	| sentencia			                                {
															printf("Regla 11: bloque es sentencia\n");
															ind_bloque = ind_sent;
														};

sentencia:
	asignacion PUNTO_COMA			                    {
															printf("Regla 12: sentencia es asignacion PUNTO_COMA\n");
															ind_sent = ind_asig;
														}
	| bloque_if                                         {
															printf("Regla 13: sentencia es bloque_if\n");
															ind_sent = ind_bif;
														}
	| bloque_while                                      {
															printf("Regla 14: sentencia es bloque_while\n");
															ind_sent = ind_bwhile;
														}
	| lectura PUNTO_COMA                                {
															printf("Regla 15: sentencia es lectura PUNTO_COMA\n");
															ind_sent = ind_lectura;
														}
	| escritura PUNTO_COMA                              {
															printf("Regla 16: sentencia es escritura PUNTO_COMA\n");
															ind_sent = ind_escritura;
														}
	| expresion_aritmetica PUNTO_COMA                   {
															printf("Regla 17: sentencia es expresion_aritmetica PUNTO_COMA\n");
															resetTipoDato();
															ind_sent = ind_expr;
														};

bloque_if:
    IF expresion_logica THEN bloque ENDIF               {
															printf("Regla 18: bloque_if es IF expresion_logica THEN bloque ENDIF\n\n");
															ind_xplogic = desapilar_xplogic();
															ind_bif = crear_terceto(IF, ind_xplogic, ind_bloque);
														};

bloque_if:
    IF expresion_logica THEN bloque_true ELSE bloque ENDIF   {
															printf("Regla 19.1: bloque_if es IF expresion_logica THEN bloque ELSE bloque ENDIF\n\n");
															int ind = crear_terceto(THEN, ind_btrue, ind_bloque);
															ind_xplogic = desapilar_xplogic();
															ind_bif = crear_terceto(IF, ind_xplogic, ind);
														}
	| IF expresion_logica THEN ENDIF					{
															printf("Regla 19.2: bloque_if es IF expresion_logica THEN ENDIF\n\n");
															ind_xplogic = desapilar_xplogic();
															ind_bif = crear_terceto(IF, ind_xplogic, NOOP);
														};

bloque_while:
    WHILE expresion_logica THEN bloque ENDWHILE         {
															printf("Regla 20.1: bloque_while es WHILE expresion_logica THEN bloque ENDWHILE\n\n");
															ind_xplogic = desapilar_xplogic();
															ind_bwhile = crear_terceto(WHILE, ind_xplogic, ind_bloque);
														}
	| WHILE expresion_logica ENDWHILE					{
															printf("Regla 20.2: bloque_while es WHILE expresion_logica ENDWHILE\n\n");
															ind_xplogic = desapilar_xplogic();
															ind_bwhile = crear_terceto(WHILE, ind_xplogic, NOOP);
														};

asignacion:
	ID ASIG {strcpy(idAsignar, $1);} expresion	        {
															printf("Regla 21: asignacion es ID(%s) ASIG expresion\n\n", idAsignar);
															int tipo = chequearVarEnTabla(idAsignar);
															chequearTipoDato(tipo);
															resetTipoDato();
															int pos=buscarEnTabla(idAsignar);
															ind_asig = crear_terceto(ASIG, pos, ind_xp);
														};

bloque_true:
	bloque												{
															printf("Regla 21.1: bloque_true es bloque\n");
															ind_btrue = ind_bloque;
														};

/* Expresiones aritmeticas y otras */

expresion:
	expresion_cadena				                    {
															printf("Regla 22: expresion es expresion_cadena\n");
															ind_xp = ind_xpcad;
														}
	| expresion_aritmetica			                    {
															printf("Regla 23: expresion es expresion_aritmetica\n");
															ind_xp = ind_expr;
														};

expresion_cadena:
	CTE_STRING						                    {
															printf("Regla 24: expresion_cadena es CTE_STRING(%s)\n", $1);
															int pos=agregarCteStringATabla(yylval.string_val);
															ind_xpcad = crear_terceto(NOOP,pos,NOOP);
														};

expresion_aritmetica:
	expresion_aritmetica MAS termino_r 		            {
															printf("Regla 25: expresion_aritmetica es expresion_aritmetica MAS termino_r\n");
															ind_expr = crear_terceto(MAS, ind_expr, ind_rterm);
														}
	| expresion_aritmetica MENOS termino_r 	            {
															printf("Regla 26: expresion_aritmetica es expresion_aritmetica MENOS termino_r\n");
															ind_expr = crear_terceto(MENOS, ind_expr, ind_rterm);
														}
	| termino								            {
															printf("Regla 27: expresion_aritmetica es termino\n");
															ind_expr = ind_term;
														};

termino_r:
	termino POR factor 			                        {
															printf("Regla 28: termino_r es termino POR factor\n");
															ind_rterm = crear_terceto(POR, ind_term, ind_factor);
														}
	| termino DIVIDIDO factor 	                        {
															printf("Regla 29: termino_r es termino DIVIDIDO factor\n");
															ind_rterm = crear_terceto(DIVIDIDO, ind_term, ind_factor);
														}
	| factor					                        {
															printf("Regla 30: termino_r es factor\n");
															ind_rterm = ind_factor;
														};

termino:
	termino_r											{
															printf("Regla 30.1: termino es temrino_r\n");
															ind_term = ind_rterm;
														}
	| pre												{
															printf("Regla 30.2: termino es pre\n");
															ind_term = ind_pre;
														};

pre:
	MAS factor											{
															printf("Regla 30.2: pre es MAS factor\n");
															ind_pre = ind_factor;
														}
	| MENOS factor										{
															printf("Regla 30.3: pre es MENOS factor\n");

															ind_pre = crear_terceto(MENOS, ind_factor, NOOP);
														};

factor:
	PA expresion_aritmetica PC	                        {
															printf("Regla 31: factor es PA expresion_aritmetica PC\n");
															ind_factor = ind_expr;
														}
    | average                                           {
															printf("Regla 32: factor es average\n");
															ind_factor = ind_avg;
														}
	| ID			                                    {
															printf("Regla 33: factor es ID(%s)\n", $1);
															int tipo = chequearVarEnTabla(yylval.string_val);
															chequearTipoDato(tipo);

															int pos = buscarEnTabla($1);
															ind_factor = crear_terceto(NOOP, pos, NOOP);
														}
	| CTE_FLOAT	                                        {
															printf("Regla 34: factor es CTE_FLOAT(%f)\n", $1);
															chequearTipoDato(Float);
															int pos = agregarCteFloatATabla(yylval.float_val);
															ind_factor = crear_terceto(NOOP, pos, NOOP);
														}
	| CTE_INT	                                        {
															printf("Regla 35: factor es CTE_INT(%d)\n", $1);
															chequearTipoDato(Int);
															int pos = agregarCteIntATabla(yylval.int_val);
															ind_factor = crear_terceto(NOOP, pos, NOOP);
														};
/* Expresiones logicas */

expresion_logica:
    termino_logico_izq AND termino_logico               {
															printf("Regla 36: expresion_logica es termino_logico AND termino_logico\n");
															ind_xplogic = crear_terceto(AND, ind_tlogic_izq, ind_tlogic);
															apilar_xplogic(ind_xplogic);
														}
    | termino_logico_izq OR termino_logico              {
															printf("Regla 37: expresion_logica es termino_logico OR termino_logico\n");
															ind_xplogic = crear_terceto(OR, ind_tlogic_izq, ind_tlogic);
															apilar_xplogic(ind_xplogic);
														}
    | termino_logico                                    {
															printf("Regla 38: expresion_logica es termino_logico\n");
															ind_xplogic = ind_tlogic;
															apilar_xplogic(ind_xplogic);
															ind_branch_pendiente = crear_terceto(saltarFalse(comp_bool_actual), ind_tlogic, NOOP);
														}
    | NOT termino_logico                                {
															printf("Regla 39: expresion_logica es NOT termino_logico\n");
															ind_xplogic = crear_terceto(NOT, ind_tlogic, NOOP);
															apilar_xplogic(ind_xplogic);
														};

termino_logico_izq:
		termino_logico									{
															printf("Regla 39.1: termino_logico_izq es termino_logico\n");
															ind_tlogic_izq = ind_tlogic;
														};

termino_logico:
    expr_aritmetica_izquierda comp_bool expresion_aritmetica {
															printf("Regla 40: termino_logico es expr_aritmetica_izquierda comp_bool expresion_aritmetica\n");
															resetTipoDato();
															ind_tlogic = crear_terceto(CMP, ind_expr_izq, ind_expr);
														}
    | inlist                                            {
															printf("Regla 41: termino logico es inlist\n");
															ind_tlogic = ind_inlist;
														};

expr_aritmetica_izquierda:
	expresion_aritmetica								{
															printf("Regla 41.1: expr_aritmetica_izquierda es expresion_aritmetica\n");
															ind_expr_izq = ind_expr;
														}

comp_bool:
    MENOR                                               {
															printf("Regla 42: comp_bool es MENOR\n");
															comp_bool_actual = MENOR;
														}
    |MAYOR                                              {
															printf("Regla 43: comp_bool es MAYOR\n");
															comp_bool_actual = MAYOR;
														}
    |MENOR_IGUAL                                        {
															printf("Regla 44: comp_bool es MENOR_IGUAL\n");
															comp_bool_actual = MENOR_IGUAL;
														}
    |MAYOR_IGUAL                                        {
															printf("Regla 45: comp_bool es MAYOR_IGUAL\n");
															comp_bool_actual = MAYOR_IGUAL;
														}
    |IGUAL                                              {
															printf("Regla 46: comp_bool es IGUAL\n");
															comp_bool_actual = IGUAL;
														}
    |DISTINTO                                           {
															printf("Regla 47: comp_bool es DISTINTO\n");
															comp_bool_actual = DISTINTO;
														};

/* Funciones nativas */

average:
    AVG PA CA lista_exp_coma CC PC                      {
															printf("Regla 48: average es AVG PA CA lista_exp_coma CC PC\n\n");
															int pos = agregarCteIntATabla(cant);
															ind_avg = crear_terceto(DIVIDIDO, ind_lec, pos);
														};

inlist:
	INLIST PA ID PUNTO_COMA CA lista_exp_pc CC PC   	{
															printf("Regla 49: inlist es INLIST PA ID(%s) PUNTO_COMA CA lista_exp_pc CC PC\n\n", $3);
															int tipo = chequearVarEnTabla($3);
															chequearTipoDato(tipo);
															resetTipoDato();
															int pos=chequearVarEnTabla($3);
															ind_inlist = crear_terceto(INLIST, pos, ind_lepc);
														};

lista_exp_coma:
    lista_exp_coma COMA expresion_aritmetica            {
															printf("Regla 50: lista_exp_coma es lista_exp_coma COMA expresion_aritmetica\n");
															ind_lec = crear_terceto(MAS, ind_lec, ind_expr);
															cant++;
														}
    | expresion_aritmetica                              {
															printf("Regla 51: lista_exp_coma es expresion_aritmetica\n");
															ind_lec = ind_expr;
															cant = 1;
														};

lista_exp_pc:
    lista_exp_pc PUNTO_COMA expresion_aritmetica        {
															printf("Regla 52: lista_exp_pc es lista_exp_pc PUNTO_COMA expresion_aritmetica\n");
															ind_lepc = crear_terceto(PUNTO_COMA, ind_lepc, ind_expr);
														}
    | expresion_aritmetica                              {
															printf("Regla 53: lista_exp_pc es expresion_aritmetica\n");
															ind_lepc = ind_expr;
														};

lectura:
    READ ID												{
															printf("Regla 54: lectura es READ ID(%s)\n", $2);
															chequearVarEnTabla($2);
															int pos = buscarEnTabla($2);
															ind_lectura = crear_terceto(READ, pos, NOOP);
														};

escritura:
    WRITE ID                                            {
															printf("Regla 55: escritura es WRITE ID(%s)\n", $2);
															chequearVarEnTabla($2);
															int pos = buscarEnTabla($2);
															ind_escritura = crear_terceto(WRITE, pos, NOOP);
														}
    | WRITE CTE_STRING                                  {
															printf("Regla 56: escritura es WRITE CTE_STRING(%s)\n\n", $2);
															int pos = agregarCteStringATabla(yylval.string_val);
															ind_escritura = crear_terceto(WRITE, pos, NOOP);
														};
%%

int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	yyparse();
  	fclose(yyin);
  }
  return 0;
}


int yyerror(char* mensaje)
 {
	printf("Syntax Error: %s\n", mensaje);
	system ("Pause");
	exit (1);
 }

/* Funciones de la tabla de simbolos */

/* Devuleve la posici�n en la que se encuentra el elemento buscado, -1 si no encontr� el elemento */
int buscarEnTabla(char * name){
   int i=0;
   while(i<=fin_tabla){
	   if(strcmp(tabla_simbolo[i].nombre,name) == 0){
		   return i;
	   }
	   i++;
   }
   return -1;
}

/** Escribe el nombre de una variable o constante en la posición indicada */
void escribirNombreEnTabla(char* nombre, int pos){
	strcpy(tabla_simbolo[pos].nombre, nombre);
}

/** Agrega un nuevo nombre de variable a la tabla **/
void agregarVarATabla(char* nombre){
 //Si se llena, error
 if(fin_tabla >= TAMANIO_TABLA - 1){
	 printf("Error: me quede sin espacio en la tabla de simbolos. Sori, gordi.\n");
	 system("Pause");
	 exit(2);
 }
 //Si no hay otra variable con el mismo nombre...
 if(buscarEnTabla(nombre) == -1){
	 //Agregar a tabla
	 fin_tabla++;
	 escribirNombreEnTabla(nombre, fin_tabla);
 }
 else yyerror("Encontre dos declaraciones de variables con el mismo nombre. Decidite."); //Error, ya existe esa variable
}

/** Agrega los tipos de datos a las variables declaradas. Usa las variables globales varADeclarar1, cantVarsADeclarar y tipoDatoADeclarar */
void agregarTiposDatosATabla(){
	for(int i = 0; i < cantVarsADeclarar; i++){
		tabla_simbolo[varADeclarar1 + i].tipo_dato = tipoDatoADeclarar;
	}
}

/** Guarda la tabla de simbolos en un archivo de texto */
void guardarTabla(){
	if(fin_tabla == -1)
		yyerror("No encontre la tabla de simbolos");

	FILE* arch = fopen("ts.txt", "w+");
	if(!arch){
		printf("No pude crear el archivo ts.txt\n");
		return;
	}

	for(int i = 0; i <= fin_tabla; i++){
		fprintf(arch, "%s\t", &(tabla_simbolo[i].nombre) );

		switch (tabla_simbolo[i].tipo_dato){
		case Float:
			fprintf(arch, "FLOAT");
			break;
		case Int:
			fprintf(arch, "INT");
			break;
		case String:
			fprintf(arch, "STRING");
			break;
		case CteFloat:
			fprintf(arch, "CTE_FLOAT\t%f", tabla_simbolo[i].valor_f);
			break;
		case CteInt:
			fprintf(arch, "CTE_INT\t%d", tabla_simbolo[i].valor_i);
			break;
		case CteString:
			fprintf(arch, "CTE_STRING\t%s\t%d", &(tabla_simbolo[i].valor_s), tabla_simbolo[i].longitud);
			break;
		}

		fprintf(arch, "\n");
	}
	fclose(arch);
}

/* Calculo que estas 3 funciones se podrían juntar en una sola */

/** Agrega una constante string a la tabla de simbolos */
int agregarCteStringATabla(char* nombre){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		printf("Error: me quede sin espacio en la tabla de simbolos. Sori, gordi.\n");
		system("Pause");
		exit(2);
	}

	//Preparo el nombre. Nuestras constantes empiezan con _ en la tabla de simbolos
	char nuevoNombre[strlen(nombre)+2]; //+2 para agregarle el _ al inicio y el \0 al final
	sprintf(nuevoNombre, "_%s", nombre);

	int pos=buscarEnTabla(nuevoNombre);
	//Si no hay otra constante string con el mismo nombre...
	if(pos == -1){
		//Agregar nombre a tabla
		fin_tabla++;
		escribirNombreEnTabla(nuevoNombre, fin_tabla);

		//Agregar tipo de dato
		tabla_simbolo[fin_tabla].tipo_dato = CteString;

		//Agregar valor a la tabla
		strcpy(tabla_simbolo[fin_tabla].valor_s, nombre);

		//Agregar longitud
		tabla_simbolo[fin_tabla].longitud = strlen(nombre) - 1;

		pos=fin_tabla;
	}
	return pos;
}

/** Agrega una constante real a la tabla de simbolos */
int agregarCteFloatATabla(float valor){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		printf("Error: me quede sin espacio en la tabla de simbolos. Sori, gordi.\n");
		system("Pause");
		exit(2);
	}

	//Genero el nombre
	char nombre[12];
	sprintf(nombre, "_%f", valor);
	int pos=buscarEnTabla(nombre);
	//Si no hay otra variable con el mismo nombre...
	if(pos == -1){
		//Agregar nombre a tabla
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);

		//Agregar tipo de dato
		tabla_simbolo[fin_tabla].tipo_dato = CteFloat;

		//Agregar valor a la tabla
		tabla_simbolo[fin_tabla].valor_f = valor;
		pos = fin_tabla;
	}
	return pos;
}

/** Agrega una constante entera a la tabla de simbolos */
int agregarCteIntATabla(int valor){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		printf("Error: me quede sin espacio en la tabla de simbolos. Sori, gordi.\n");
		system("Pause");
		exit(2);
	}

	//Genero el nombre
	char nombre[30];
	sprintf(nombre, "_%d", valor);
	int pos=buscarEnTabla(nombre);

	//Si no hay otra variable con el mismo nombre...
	if(pos == -1){
		//Agregar nombre a tabla
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);

		//Agregar tipo de dato
		tabla_simbolo[fin_tabla].tipo_dato = CteInt;

		//Agregar valor a la tabla
		tabla_simbolo[fin_tabla].valor_i = valor;
		pos = fin_tabla;
	}
	return pos;
}

/** Se fija si ya existe una entrada con ese nombre en la tabla de simbolos.
Si no existe, muestra un error de variable sin declarar y aborta la compilacion.
Si existe, devuelve el tipo de dato de esa variable. */
int chequearVarEnTabla(char* nombre){
	int pos = buscarEnTabla(nombre);
	//Si no existe en la tabla, error
	if( pos == -1){
		char msg[100];
		sprintf(msg,"%s? No, man, tenes que declarar las variables arriba. Esto no es un viva la pepa como java...", nombre);
		yyerror(msg);
	}
	//Si existe en la tabla, devuelvo el tipo de dato
	return tabla_simbolo[pos].tipo_dato;
}

/** Compara el tipo de dato pasado por parámetro contra el que se está trabajando actualmente en tipoDatoActual.
Si es distinto, tira error. Si no hay tipo de dato actual, asigna el pasado por parámetro. */
void chequearTipoDato(int tipo){
	if(tipoDatoActual == sinTipo){
		tipoDatoActual = tipo;
		return;
	}
	if(tipoDatoActual != tipo)
		yyerror("me estas mezclando numeros enteros con reales. Por que me odias tanto?");
}

/** Vuelve tipoDatoActual a sinTipo */
void resetTipoDato(){
	tipoDatoActual = sinTipo;
}

/** Agrega un terceto a la lista de tercetos. Si se quiere guardar solo una constante o variable, mandar NOOP en
el campo de operador y op2. Para los operadores pasar el token literal, para los operandos pasar la posicion en
tabla de simbolos o el indice de otro terceto. */
int crear_terceto(int operador, int op1, int op2){
	ultimo_terceto++;
	if(ultimo_terceto >= MAX_TERCETOS){
		printf("Error: me quede sin espacio en para los tercetos. Optimiza tu codigo.\n");
		system("Pause");
		exit(3);
	}

	lista_terceto[ultimo_terceto].operador = operador;
	lista_terceto[ultimo_terceto].op1 = op1;
	lista_terceto[ultimo_terceto].op2 = op2;
	return ultimo_terceto + OFFSET;
}

/** Moidifica el terceto con el indice indicado en la posicion indicada. El indice debe ser sin el OFFSET
y la posicion debe ser OP1, OP2 u OPERADOR. Si el terceto no existe, aborta la compilacion. */
void modificarTerceto(int indice, int posicion, int valor){
	if(indice > ultimo_terceto){
		printf("Ups, algo fallo. Intente modificar un terceto que no existe. Mala mia.");
		system ("Pause");
		exit (4);
	}
	switch(posicion){
	case OP1:
		lista_terceto[indice].op1 = valor;
		break;
	case OP2:
		lista_terceto[indice].op2 = valor;
		break;
	case OPERADOR:
		lista_terceto[indice].operador = valor;
		break;
	}
}

/* Guarda los tercetos generados en un archivo */
void guardarTercetos(){
	if(ultimo_terceto == -1)
		yyerror("No encontre los tercetos");

	FILE* arch = fopen("intermedia.txt", "w+");
	if(!arch){
		printf("No pude crear el archivo intermedia.txt\n");
		return;
	}

	for(int i = 0; i <= ultimo_terceto; i++){
		//La forma es [i] (operador, op1, op2)
		//Escribo indice
		fprintf(arch, "[%d] (", i + OFFSET);

		//escribo operador
		switch(lista_terceto[i].operador){
		case NOOP:
			fprintf(arch, "---");
			break;
		case BLOQ:
			fprintf(arch, "sentencia");
			break;
		case START:
			fprintf(arch, "start");
			break;
		case ID:
			fprintf(arch, "declaracion");
			break;
		case IF:
			fprintf(arch, "if");
			break;
		case THEN:
			fprintf(arch, "cuerpoIf");
			break;
		case WHILE:
			fprintf(arch, "while");
			break;
		case ASIG:
			fprintf(arch, "<-");
			break;
		case MAS:
			fprintf(arch, "+");
			break;
		case MENOS:
			fprintf(arch, "-");
			break;
		case POR:
			fprintf(arch, "*");
			break;
		case DIVIDIDO:
			fprintf(arch, "/");
			break;
		case AND:
			fprintf(arch, "y");
			break;
		case OR:
			fprintf(arch, "o");
			break;
		case NOT:
			fprintf(arch, "no");
			break;
		case MENOR:
			fprintf(arch, "<");
			break;
		case MAYOR:
			fprintf(arch, ">");
			break;
		case MENOR_IGUAL:
			fprintf(arch, "<=");
			break;
		case MAYOR_IGUAL:
			fprintf(arch, ">=");
			break;
		case IGUAL:
			fprintf(arch, "==");
			break;
		case DISTINTO:
			fprintf(arch, "=/=");
			break;
		case AVG:
			fprintf(arch, "avg");
			break;
		case INLIST:
			fprintf(arch, "inlist");
			break;
		case COMA:
			fprintf(arch, "\',\'");
			break;
		case PUNTO_COMA:
			fprintf(arch, "\';\'");
			break;
		case READ:
			fprintf(arch, "leeme");
			break;
		case WRITE:
			fprintf(arch, "mostrame");
			break;
		case CMP:
			fprintf(arch, "CMP");
			break;
		case BNE:
			fprintf(arch, "BNE");
			break;
		case BEQ:
			fprintf(arch, "BEQ");
			break;
		case BGT:
			fprintf(arch, "BGT");
			break;
		case BGE:
			fprintf(arch, "BGE");
			break;
		case BLE:
			fprintf(arch, "BLE");
			break;
		case BLT:
			fprintf(arch, "BLT");
			break;
		default:
			fprintf(arch, "algo esta mal");
			break;
		}

		fprintf(arch, ", ");
		//Escribo op1
		int op = lista_terceto[i].op1;

		if(op == NOOP)
			fprintf(arch, "---");
		else if(op < TAMANIO_TABLA){
			//Es una entrada a tabla de simbolos
			fprintf(arch, "%s", &(tabla_simbolo[op].nombre) );
		}
		else //Es el indice de otro terceto
			fprintf(arch, "[%d]", op);

		fprintf(arch, ", ");
		//Escribo op2
		op = lista_terceto[i].op2;
		if(op == NOOP)
			fprintf(arch, "---");
		else if(op < TAMANIO_TABLA){
			//Es una entrada a tabla de simbolos
			fprintf(arch, "%s", &(tabla_simbolo[op].nombre) );
		}
		else //Es el indice de otro terceto
			fprintf(arch, "[%d]", op);

		fprintf(arch, ")\n");
	}
	fclose(arch);
}

void apilar_xplogic(int indice){
	ultimo_pila_ind_xplogic++;
	if(ultimo_pila_ind_xplogic >= MAX_ANIDAMIENTOS)
		yyerror("para un poco. Para que tantos anidamientos? Hasta 9 me banco.");

	pila_ind_xplogic[ultimo_pila_ind_xplogic] = indice;
}

int desapilar_xplogic(){
	int aux = pila_ind_xplogic[ultimo_pila_ind_xplogic];
	ultimo_pila_ind_xplogic--;
	return aux;
}

int saltarFalse(int comp){
	switch(comp){
	case MAYOR:
		return BLE;
	case MAYOR_IGUAL:
		return BLT;
	case MENOR:
		return BGE;
	case MENOR_IGUAL:
		return BGT;
	case IGUAL:
		return BNE;
	case DISTINTO:
		return BEQ;
	}
	return NOOP;
}
