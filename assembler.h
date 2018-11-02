#ifndef assembler_h
#define assembler_h

#include "tercetos.h"

void generarAssembler();

//Variables externas
extern simbolo tabla_simbolo[TAMANIO_TABLA];
extern terceto lista_terceto[MAX_TERCETOS];
extern int ultimo_terceto;

#endif
