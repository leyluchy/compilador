%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <conio.h>
	#include <string.h>
	#include "y.tab.h"
	
    #define Int 1
	#define Float 2
	#define String 3
	#define CteInt 4
	#define CteFloat 5
	#define CteString 6
	
	#define TAMANIO_TABLA 300

	int yyerror(char* mensaje);
	void agregarVarATabla(char* nombre);
	int buscarEnTabla(char * name);

	int yystopparser=0;
	FILE  *yyin;

	typedef struct {
		char* nombre;
		int tipo_dato;
		char* valor_s;
		float valor_f;
		int valor_i;
		int longitud;
	} simbolo;

	simbolo tabla_simbolo[TAMANIO_TABLA];
	int fin_tabla = -1;
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
%token MAS MENOS
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
%token <float>CTE_FLOAT
%token <int>CTE_INT
%token <string_val>CTE_STRING

%%

programa:
	START seccion_declaracion bloque END 	{printf("\nCOMPILACION EXITOSA\n");};

 /* Declaracion de variables */
seccion_declaracion:
	DECVAR bloque_dec ENDDEC 				{printf("Regla 1: Seccion declaracion es DECVAR bloque_dec ENDEC\n");};

bloque_dec:
	bloque_dec declaracion					{printf("Regla 2: bloque_dec es bloque_dec declaracion\n");}
	| declaracion							{printf("Regla 3: bloque_dec es declaracion\n");};

declaracion:
	t_dato lista_id PUNTO_COMA				{printf("Regla 4: declaracion es t_dato lista_id PUNTO_COMA\n");};

t_dato:
	FLOAT		{printf("Regla 5: t_dato es FLOAT\n");}
	| INT		{printf("Regla 6: t_dato es INT\n");}
	| STRING	{printf("Regla 7: t_dato es STRING\n");};

lista_id:
	lista_id COMA ID	{
							printf("Regla 8: lista_id es lista_id COMA ID | ID: %s\n", yylval.string_val);
							agregarVarATabla(yylval.string_val);
						}
	| ID				{	
							printf("Regla 9: lista_id es ID | ID: %s\n", yylval.string_val);
							agregarVarATabla(yylval.string_val);
						};

 /* Seccion de codigo */
bloque:
	bloque sentencia	{printf("Regla 10: bloque es bloque sentencia\n");}
	| sentencia			{printf("Regla 11: bloque es sentencia\n");};

sentencia:
	asignacion PUNTO_COMA			{printf("Regla 12: sentencia es asignacion PUNTO_COMA\n");};
	| bloque_if 
	| bloque_while 
	| lectura PUNTO_COMA 
	| escritura PUNTO_COMA 
	| expresion_aritmetica PUNTO_COMA;
	/* puede no haber sentencias? lo mismo para if y while, la expresion_aritmetica est� porque si */

bloque_if:
    IF expresion_logica THEN bloque ENDIF{printf("\nBloque if completado");};

bloque_if:
    IF expresion_logica THEN bloque ELSE bloque ENDIF{printf("\nBloque if completado");};

bloque_while:
    WHILE expresion_logica bloque ENDWHILE{printf("\nBloque while completado");};

asignacion:
	ID ASIG expresion	{printf("\nRegla 13");}; /* terminar de desarrollar, puede ser una exp aritmetica, o una cadena, as� que es una expresion */

expresion:
	expresion_cadena				{printf("Regla 14\n");}
	| expresion_aritmetica			{printf("Regla 15\n");};

expresion_cadena:
	CTE_STRING						{printf("Regla 16\n");};

expresion_aritmetica:
	expresion_aritmetica MAS termino 		{printf("Regla 17\n");}
	| expresion_aritmetica MENOS termino 	{printf("Regla 18\n");}
	| termino								{printf("Regla 19\n");};

termino:
	termino POR factor 			{printf("Regla 20\n");}
	| termino DIVIDIDO factor 	{printf("Regla 21\n");}
	| factor					{printf("Regla 22\n");};

factor:
	PA expresion_aritmetica PC	{printf("\nRegla 23");} /* puedo multiplicar por una string? ya no xD */
    | average;

factor:
	ID			{printf("Regla 24\n");};
	| CTE_FLOAT	{printf("Regla 25\n");}
	| CTE_INT	{printf("Regla 26\n");}; /* de aca para atras esta mas o menos listo */

expresion_logica:                             /* (algo) && (algo) O (algo) || (algo) O (algo), por si no queda claro */
    expresion_logica AND termino_logico{printf("\nExpresion logica encontrada");}
    | expresion_logica OR termino_logico{printf("\nExpresion logica encontrada");}
    | termino_logico{printf("\nExpresion logica encontrada");}
    | NOT termino_logico{printf("\nExpresion logica encontrada");};

termino_logico:
    expresion_aritmetica comp_bool expresion_aritmetica{printf("\nTermino logico encontrada");}
    | inlist;

comp_bool:
    MENOR{printf("\nComparador booleano hallado");}
    |MAYOR{printf("\nComparador booleano hallado");}
    |MENOR_IGUAL{printf("\nComparador booleano hallado");}
    |MAYOR_IGUAL{printf("\nComparador booleano hallado");}
    |IGUAL{printf("\nComparador booleano hallado");}
    |DISTINTO{printf("\nComparador booleano hallado");};

average:
    AVG PA CA lista_exp_coma CC PC;

inlist:
    INLIST PA ID PUNTO_COMA CA lista_exp_pc CC PC;

lista_exp_coma:
    lista_exp_coma COMA expresion_aritmetica
    | expresion_aritmetica;

lista_exp_pc:
    lista_exp_pc PUNTO_COMA expresion_aritmetica
    | expresion_aritmetica;

lectura:
    READ ID;

escritura:
    WRITE ID
    | WRITE CTE_STRING;

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
		 tabla_simbolo[fin_tabla].nombre = (char*) malloc((strlen(nombre)+1)*sizeof(char));
		 strcpy(tabla_simbolo[fin_tabla].nombre, nombre);
	 }
	 else yyerror("Encontre dos declaraciones de variables con el mismo nombre. Decidite."); //Error, ya existe esa variable
		 
 }
 
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
