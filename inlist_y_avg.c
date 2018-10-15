#include "inlist_y_avg.h"

/** Apila los indices de termino, termino_r, pre, factor y average para entrar
* en un average o inlist.
*/
void apilar_IAEA(){
	ult_pos_pila_exp++;
	if(ult_pos_pila_exp>=MAX_ANIDAMIENTOS){
		yyerror("para un poco. Para que tantos anidamientos? Hasta 9 me banco.");
	}

	info_anidamiento_exp_aritmeticas aux;
	aux.ind_rterm=ind_rterm;
	aux.ind_term=ind_term;
	aux.ind_expr = ind_expr;
	pila_exp[ult_pos_pila_exp] = aux;
}

/** Saca de la pila y reescribe los indices de termino, termino_r, pre, factor
* y average cuando sale de un average o inlist.
*/
void desapilar_IAEA(){
	info_anidamiento_exp_aritmeticas aux=pila_exp[ult_pos_pila_exp];
	ult_pos_pila_exp--;

	ind_rterm=aux.ind_rterm;
	ind_term=aux.ind_term;
	ind_expr = aux.ind_expr;
}
