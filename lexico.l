%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <conio.h>
	#include <string.h>
	#include "y.tab.h"

	int cota_error(char* mensaje);

	FILE  *yyin;
%}

%option noyywrap
%option yylineno

DIGITO 	[0-9]
LETRA 	[a-zA-ZñÑ]
ID		{LETRA}({LETRA}|{DIGITO})*
CTE_INT		{DIGITO}+
CTE_FLOAT	{DIGITO}+"."{DIGITO}*|{DIGITO}*"."{DIGITO}+
WHATEVER	{LETRA}|{DIGITO}|.
CTE_STRING	\"{WHATEVER}*\"
COMENTARIO	\-\/.*\/\-
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
									//yylval.string_val = yytext;
									yylval.string_val = strdup(yytext);
									printf("\n** LEX leyo la ID %s **\n", yylval.string_val);
									return ID;
								}
								cota_error("intenta limitar tus nombres de variables a 30 caracteres. Dale, soy generoso.");
							}
{CTE_INT}					{
								if(atoll(yytext)<=2147483647){
									yylval.int_val = atoi(yytext);
									return CTE_INT;
								}
								cota_error("superaste el tamanio maximo para numeros enteros. Realmente necesitas un numero tan grande?");
							}
{CTE_FLOAT}					{

								yylval.float_val = atof(yytext);
								return CTE_FLOAT;
							}
{CTE_STRING}				{
								if(strlen(yytext)<=30){

									int length = strlen(yytext);
									char nombre_cte[length];
									strcpy(nombre_cte, "_");
									strcat(nombre_cte, yytext+1);
									strcpy(nombre_cte + strlen(nombre_cte) - 1, "\0");
									strcpy(yylval.string_val, nombre_cte);

									return CTE_STRING;
								}
								cota_error("intenta limitar tus jeroglificos a 30 caracteres.");
							}
{COMENTARIO}
{ESPACIO}
\n
\t

%%

int cota_error(char* mensaje)
{
	printf("Error lexico: %s\n", mensaje);
	system ("Pause");
	exit (1);
}
