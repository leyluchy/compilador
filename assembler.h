#ifndef assembler_h
#define assembler_h

#include <stdio.h>
#include "tercetos.h"

void generarAssembler();
void escribirInicio(FILE* arch);
void generarTabla(FILE* arch);

//Variables externas
extern simbolo tabla_simbolo[TAMANIO_TABLA];
extern int fin_tabla;
extern terceto lista_terceto[MAX_TERCETOS];
extern int ultimo_terceto;

#endif
