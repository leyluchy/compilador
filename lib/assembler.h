#ifndef assembler_h
#define assembler_h

#include <stdio.h>
#include "tercetos.h"

void generarAssembler();
void escribirInicio(FILE* arch);
void escribirFinal(FILE *arch);
void generarTabla(FILE* arch);
void escribirEtiqueta(FILE* arch, char* etiqueta, int n);
void escribirSalto(FILE* arch, char* salto, int tercetoDestino);
void asignacion(FILE* arch, int terceto);
void comparacion(FILE* arch, int terceto);
void levantarEnPila(FILE* arch, const int ind);
void write(FILE* arch, int ind);

//Variables externas
extern simbolo tabla_simbolo[TAMANIO_TABLA];
extern int fin_tabla;
extern terceto lista_terceto[MAX_TERCETOS];
extern int ultimo_terceto;

#endif
