#ifndef inlist_y_avg_h
#define inlist_y_avg_h

#include "sentencias_control.h"

/* Funciones */
void apilar_IAEA();
void desapilar_IAEA();

int yyerror(char* mensaje);

typedef struct{
  int ind_rterm;
  int ind_term;
  int ind_expr;
} info_anidamiento_exp_aritmeticas;

/* Variables externas */
extern info_anidamiento_exp_aritmeticas pila_exp[MAX_ANIDAMIENTOS];
extern int ult_pos_pila_exp;
extern int ind_rterm;
extern int ind_term;
extern int ind_expr;

#endif
