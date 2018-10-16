%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <conio.h>
	#include <string.h>
	#include "y.tab.h"

	int error(char* mensaje);

	FILE  *yyin;
%}

%option noyywrap
%option yylineno
%x comment
%x inner_comment

DIGITO 	[0-9]
LETRA 	[a-zA-ZñÑ]
ID		{LETRA}({LETRA}|{DIGITO})*
CTE_INT		{DIGITO}+
CTE_FLOAT	{DIGITO}+"."{DIGITO}*|{DIGITO}*"."{DIGITO}+
WHATEVER	{LETRA}|{DIGITO}|.
CTE_STRING	\"{WHATEVER}*\"
ESPACIO     " "

%%
 /* Inicio y fin de programa */
"estimada_cajita_magica"	{ return START;}
"salu2"						{ return END;}

 /* Seccion de declaracion de variables y tipos de datos */
"necesito:"					{ return DECVAR;}
"para"						{ return ENDDEC;}
"enterito"					{ return INT;}
"discretito"				{ return INT;}
"posta"						{ return FLOAT;}
"jeroglifico"				{ return STRING;}

 /* Bloques de control */
"mientras"					{ return WHILE;}
"goto_mientras"				{ return ENDWHILE;}
"si"						{ return IF;}
"por_favor"					{ return THEN;}
"sino"						{ return ELSE;}
"gracias"					{ return ENDIF;}

 /* Operadores logicos */
"y"							{ return AND;}
"o"							{ return OR;}
"no"						{ return NOT;}

 /* Operadores */
"<-"						{ return ASIG;}
"+"							{ return MAS;}
"-"							{ return MENOS;}
"*"							{ return POR;}
"/"							{ return DIVIDIDO;}

 /* Comparadores */
"<"							{ return MENOR;}
">"							{ return MAYOR;}
"<="						{ return MENOR_IGUAL;}
">="						{ return MAYOR_IGUAL;}
"=="						{ return IGUAL;}
"=/="						{ return DISTINTO;}

 /* Otros simbolos */
"("							{ return PA;}
")"							{ return PC;}
"["							{ return CA;}
"]"							{ return CC;}
","							{ return COMA;}
";"							{ return PUNTO_COMA;}

 /* Funciones */
"leeme"						{ return READ;}
"mostrame"					{ return WRITE;}
"avast"						{ return AVG;}
"lta?"						{ return INLIST;}

 /* Identificadores y constantes */
{ID}						{
								if(strlen(yytext) <= 30){
									yylval.string_val = strdup(yytext);
									return ID;
								}
								error("intenta limitar tus nombres de variables a 30 caracteres. Dale, soy generoso.");
							}
{CTE_INT}					{
								if(atoll(yytext)<=2147483647){
									yylval.int_val = atoi(yytext);
									return CTE_INT;
								}
								error("superaste el tamanio maximo para numeros enteros. Realmente necesitas un numero tan grande?");
							}
{CTE_FLOAT}					{
								if(atof(yytext)<=3.40282347e+38F){
									yylval.float_val = atof(yytext);
									return CTE_FLOAT;
								}
								error("superaste el tamanio maximo para numeros posta. Realmente necesitas un numero tan grande?");
							}
{CTE_STRING}				{
								if( strlen(yytext) <= 30 + 2){ //Aceptamos hasta 30 caracteres. yytext incluye las comillas, esos son dos caracteres más que vamos a sacar
									/* yytext tiene 2 caracteres más que lo que queremos guardar.
									Pero nosotros ademas queremos anteponerle un \0, asi que hay solo un caracter extra*/
									int length = strlen(yytext-1);
									char nombre_cte[length];
									strcpy(nombre_cte, yytext+1); //Copio salteando la primer comilla
									strcpy(nombre_cte + strlen(nombre_cte) - 1, "\0"); //Sobrescribo la ultima comilla con \0
									strcpy(yylval.string_val, nombre_cte);

									return CTE_STRING;
								}
								error("intenta limitar tus jeroglificos a 30 caracteres.");
							}
"-/"        				BEGIN(comment);

<comment>[^-/\n]*       	/* como todo lo que no sea un '/' */
<comment>"-"+[^-/\n]*		/* como todos los "-" que no esten seguidos por "/" */
<comment>"/"+[^-/\n]*   	/* como los '/' que no esten seguidos por '-' */
<comment>\n             	/* como los saltos de linea, puedo contar*/
<comment>"-/"				BEGIN(inner_comment);
<inner_comment>[^/\n]*      /* como todo lo que no sea un '/' */
<inner_comment>"/"+[^-/\n]* /* como los '/' que no esten seguidos por '-' */
<inner_comment>\n       	/* como los saltos de linea, puedo contar*/
<inner_comment>"/"+"-"  	BEGIN(comment);
<comment>"/"+"-"       		BEGIN(INITIAL);
{ESPACIO}
\n
\t
\r\n
.							{ error("Que es este caracter? No lo conozco.");}

%%

int error(char* mensaje)
{
	printf("Error lexico: %s\n", mensaje);
	system ("Pause");
	exit (1);
}

int yyerror(char* mensaje)
 {
	printf("Syntax Error (linea %d): %s\n", yylineno, mensaje);
	system ("Pause");
	exit (1);
 }
