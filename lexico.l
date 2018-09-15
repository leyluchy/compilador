%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"
FILE  *yyin;
int yylval;
int cota_error(void);
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

%%

"estimada_cajita_magica"	{ return START;}
"salu2"						{ return END;}

"necesito:"					{ return DECVAR;}
"para"						{ return ENDDEC;}
"enterito"					{ return INT;}
"discretito"				{ return INT;}
"posta"						{ return FLOAT;}
"jeroglifico"				{ return STRING;}

"mientras"					{ return WHILE;}
"goto_mientras"				{ return ENDWHILE;}
"si"						{ return IF;}
"por_favor"					{ return THEN;}
"sino"						{ return ELSE;}
"gracias"					{ return ENDIF;}

"<-"						{ return ASIG;}
"+"							{ return MAS;}
"-"							{ return MENOS;}
"*"							{ return POR;}
"/"							{ return DIVIDIDO;}
"<"							{ return MENOR;}
">"							{ return MAYOR;}
"<="						{ return MENOR_IGUAL;}
">="						{ return MAYOR_IGUAL;}
"=="						{ return IGUAL;}
"=/="						{ return DISTINTO;}

"("							{ return PA;}
")"							{ return PC;}
"["							{ return CA;}
"]"							{ return CC;}
","							{ return COMA;}
";"							{ return PUNTO_COMA;}

"leeme"						{ return READ;}
"mostrame"					{ return WRITE;}
"avast"						{ return AVG;}
"lta?"						{ return INLIST;}

{ID}						{ return ID;}
{CTE_INT}					{ if(atoll(yytext)<=2147483647){
									return CTE_INT;
								}
								cota_error();
							}
{CTE_FLOAT}					{ return CTE_FLOAT;}
{CTE_STRING}				{ 	if(strlen(yytext)<=30){
									return CTE_STRING;}
								cota_error();
}
{COMENTARIO}				

%%

int cota_error(void)
{
	printf("Error lexico: cota superada\n");
	system ("Pause");
	exit (1);
}