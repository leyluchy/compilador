#include "inlist_y_avg.h"

/** Apila los indices de termino, termino_r, pre, factor y average para entrar
* en un average o inlist.
*/
void apilar_IAEA(){
	ult_pos_pila_exp++;
	if(ult_pos_pila_exp>=MAX_ANIDAMIENTOS){
		yyerror("para un poco. Para que tantos parentesis? Hasta 9 me banco.");
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

/** Apila el indice del ultimo elemento de la lista del average y el contador de
* cantidad de elementos en el average.
*/
void apilarAVG(){
	ult_pos_pilaAVG++;
	if(ult_pos_pila_exp>=MAX_ANIDAMIENTOS){
		yyerror("para un poco. Para que tantos avast uno dentro de otro? Hasta 9 me banco.");
	}

	pilaAVG[ult_pos_pilaAVG].ind_lec = ind_lec;
	pilaAVG[ult_pos_pilaAVG].cant = cant;
	pilaAVG[ult_pos_pilaAVG].etc.ind_rterm = ind_rterm;
	pilaAVG[ult_pos_pilaAVG].etc.ind_term = ind_term;
	pilaAVG[ult_pos_pilaAVG].etc.ind_expr = ind_expr;
}

/** Desapila y restaura el indice del ultimo elemento de la lista del average y
* la cantidad de elementos del average.
*/
void desapilarAVG(){
	ind_lec = pilaAVG[ult_pos_pilaAVG].ind_lec;
	cant = pilaAVG[ult_pos_pilaAVG].cant;
	ind_rterm = pilaAVG[ult_pos_pilaAVG].etc.ind_rterm;
	ind_term = pilaAVG[ult_pos_pilaAVG].etc.ind_term;
	ind_expr = pilaAVG[ult_pos_pilaAVG].etc.ind_expr;

	ult_pos_pilaAVG--;
}
