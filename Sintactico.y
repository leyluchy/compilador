%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <conio.h>
	#include "y.tab.h"

	int yyerror();

	int yystopparser=0;
	FILE  *yyin;
%}

%token START END

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

%token ID
%token CTE_FLOAT CTE_INT CTE_STRING

%%

programa: START seccion_declaracion bloque END;

seccion_declaracion: DECVAR bloque_dec ENDDEC;

bloque_dec: bloque_dec declaracion;

bloque_dec: declaracion;

declaracion: t_dato lista_id PUNTO_COMA;

t_dato: FLOAT | INT | STRING;

lista_id: lista_id COMA ID;

lista_id: ID;

bloque: bloque sentencia;

bloque: sentencia;

sentencia: asignacion | bloque_if | bloque_while | expresion_aritmetica; /* puede no haber sentencias? lo mismo para if y while, la expresion_aritmetica está porque si */

asignacion: ID ASIG expresion; /*terminar de desarrollar, puede ser una exp aritmetica, o una cadena, así que es una expresion*/

bloque_if: IF expresion_booleana THEN bloque ENDIF; /*terminar de desarrollar*/

bloque_if: IF expresion_booleana THEN bloque ELSE bloque ENDIF; /*terminar de desarrollar*/

bloque_while: WHILE expresion_booleana bloque ENDWHILE;


/* bloque:
	toquen | bloque toquen;

toquen:
 DECVAR      {printf("DECVAR ");}
 |ENDDEC     {printf("ENDDEC ");}
 |INT        {printf("INT ");}
 |FLOAT      {printf("FLOAT ");}
 |STRING     {printf("STRING ");}
 |WHILE      {printf("WHILE ");}
 |ENDWHILE   {printf("ENDWHILE ");}
 |IF         {printf("IF ");}
 |THEN       {printf("THEN ");}
 |ELSE       {printf("ELSE ");}
 |ENDIF      {printf("ENDIF ");}
 |ASIG       {printf("ASIG ");}
 |MAS        {printf("MAS ");}
 |MENOS      {printf("MENOS ");}
 |POR        {printf("POR ");}
 |DIVIDIDO   {printf("DVD ");}
 |MENOR      {printf("MENOR ");}
 |MAYOR      {printf("MAYOR ");}
 |MENOR_IGUAL{printf("MENOR_IGUAL ");}
 |MAYOR_IGUAL{printf("MAYOR_IGUAL ");}
 |IGUAL      {printf("IGUAL ");}
 |DISTINTO   {printf("DISTINTO ");}
 |PA         {printf("PA ");}
 |PC         {printf("PC ");}
 |CA         {printf("CA ");}
 |CC         {printf("CC ");}
 |COMA       {printf("COMA ");}
 |PUNTO_COMA {printf("PUNTO_COMA ");}
 |READ       {printf("READ ");}
 |WRITE      {printf("WRITE ");}
 |AVG        {printf("AVG ");}
 |INLIST    {printf("INLIST ");}
|ID			{printf("ID ");}
|CTE_FLOAT	{printf("CTE_FLOAT ");}
|CTE_INT	{printf("CTE_INT ");}
|CTE_STRING	{printf("CTE_STRING ");}
|AND	{printf("AND ");}
|OR		{printf("OR ");}
|NOT	{printf("NOT ");};  */

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


int yyerror(void)
 {
	printf("Syntax Error\n");
	system ("Pause");
	exit (1);
 }
