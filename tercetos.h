#ifndef tercetos_h
#define tercetos_h

#include "tabla_simbolos.h"

#define OFFSET TAMANIO_TABLA
#define MAX_TERCETOS 512

#define NOOP -1 /* Sin operador */
#define BLOQ 7 /* Operador que indica el orden de las sentencias */
#define CMP 21 /* Comparador de assembler */
#define BNE 2 /* = */
#define BGE 4 /* < */
#define BLT 6 /* >= */
#define BLE 10 /* > */
#define BEQ 14 /* != */
#define BGT 8 /* <= */

#define OP1 2
#define OP2 3
#define OPERADOR 1

int crear_terceto(int operador, int op1, int op2);
void guardarTercetos();
void modificarTerceto(int indice, int posicion, int valor);

typedef struct{
  int operador;
  int op1;
  int op2;
} terceto;

#endif
