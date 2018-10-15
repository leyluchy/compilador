#ifndef inlist_y_avg_h
#define inlist_y_avg_h

#include "sentencias_control.h"

/* Funciones */
void apilar_IAEA();
void desapilar_IAEA();
void apilarAVG();
void desapilarAVG();

int yyerror(char* mensaje);

//Estructura de la pila de expresiones entre parentesis
typedef struct{
  int ind_rterm;
  int ind_term;
  int ind_expr;
} info_anidamiento_exp_aritmeticas;

//Estructura de la pila de average
typedef struct{
  int ind_lec;
  int cant;
  info_anidamiento_exp_aritmeticas etc;
} info_anidamiento_avg;

/* Variables externas */
extern info_anidamiento_exp_aritmeticas pila_exp[MAX_ANIDAMIENTOS];
extern int ult_pos_pila_exp;
extern int ind_rterm;
extern int ind_term;
extern int ind_expr;

extern info_anidamiento_avg pilaAVG[MAX_ANIDAMIENTOS];
extern int ult_pos_pilaAVG;
extern int ind_lec;
extern int cant;

#endif
