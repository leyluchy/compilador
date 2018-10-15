#include "sentencias_control.h"
#include "tercetos.h"
#include "y.tab.h"

/** Dado un comparador, devuelve el branch correspondiente al salto por falso.
*/
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

/** Dado un comprador, devuelve el branch correspondiente al salto por verdadero.
*/
int saltarTrue(int comp){
	switch(comp){
	case MAYOR:
		return BGT;
	case MAYOR_IGUAL:
		return BGE;
	case MENOR:
		return BLT;
	case MENOR_IGUAL:
		return BLE;
	case IGUAL:
		return BEQ;
	case DISTINTO:
		return BNE;
	}
	return NOOP;
}

/** Apila todos los indices que utilizan if y while para saber donde tienen que
* rellenar un branch y resetea esas variables globales. Pensado para cuando se
* anidan if y whiles.
* IEP es info_elemento_pila, el nombre del struct que apila.
*/
void apilar_IEP(){
	ult_pos_pila_bloques++;
	if(ult_pos_pila_bloques>=MAX_ANIDAMIENTOS){
		yyerror("para un poco. Para que tantos anidamientos? Hasta 9 me banco.");
	}

	info_elemento_pila aux;
	aux.ind_bloque=ind_bloque;
	aux.falseIzq=falseIzq;
	aux.falseDer=falseDer;
	aux.verdadero=verdadero;
	aux.always=always;

	pila_bloques[ult_pos_pila_bloques] = aux;

	falseIzq=VALOR_NULO;
	falseDer=VALOR_NULO;
	verdadero=VALOR_NULO;
	always=VALOR_NULO;
}

/** Saca un elemento de la pila que tiene los indices que utilizan if y while para
* saber a donde tienen que rellenar un branch, y sobrescriben las variables globales.
* pensado para cuando habia if y whiles anidados y vuelvo al padre.
*/
void desapilar_IEP(){
	info_elemento_pila aux=pila_bloques[ult_pos_pila_bloques];
	ult_pos_pila_bloques--;

	ind_bloque=aux.ind_bloque;
	falseIzq=aux.falseIzq;
	falseDer=aux.falseDer;
	verdadero=aux.verdadero;
	always=aux.always;
}

/** Rellena con el indice del inicio del bloque por verdadero en el branch que
* debe saltar por verdadero.
*/
void ponerSaltosThen(){
	if(verdadero!=VALOR_NULO){ //Me di cuenta tarde de que ind_branch_pendiente y compania no hacen falta, soy un boludo
		modificarTerceto(verdadero, OP2, ind_then);
	}
}

/** Rellena con ind_else en los branch que deben saltar por falso.
* ind_else deberia apuntar al inicio del bloque por falso o al final del if.
*/
void ponerSaltosElse(){
	if(falseIzq!=VALOR_NULO){
		modificarTerceto(falseIzq, OP2, ind_else);
	}
	if(falseDer!=VALOR_NULO){
		modificarTerceto(falseDer, OP2, ind_else);
	}
}

/** Rellena con el indice del final del if en el branch obligatorio al final del
* bloque por verdadero.
*/
void ponerSaltoEndif(){
	if(always!=VALOR_NULO){
		modificarTerceto(always, OP1, ind_endif);
	}
}

/**
*/
void ponerSaltoEndwhile(){
	if(falseIzq!=VALOR_NULO){
		modificarTerceto(falseIzq, OP2, always);
	}
	if(falseDer!=VALOR_NULO){
		modificarTerceto(falseDer, OP2, always);
	}
}
