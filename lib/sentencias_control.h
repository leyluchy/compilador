#ifndef sentencias_control_h
#define sentencias_control_h

#define MAX_ANIDAMIENTOS 10
#define VALOR_NULO -1

/* Funciones */
int saltarFalse(int comp);
int saltarTrue(int comp);
void apilar_IEP();
void desapilar_IEP();

void ponerSaltosThen();
void ponerSaltosElse();
void ponerSaltoEndif();
void ponerSaltoEndwhile();

int yyerror(char* mensaje);

/* Pila de cosas para tercetos */
typedef struct{
  int ind_bloque; //Apilamos el bloque actual

  int falseIzq; //Si se pasa por false el bool izquierdo
  int falseDer; //Si se pasa por false el bool derecho
  int verdadero; //Si hay un OR, el lado izq
  int always; //Para los else, y los endwhile
} info_elemento_pila;

/* Variables externas */

/* Cosas para anidamientos de if y while */
extern int falseIzq;
extern int falseDer;
extern int verdadero;
extern int always;
/* Indices */
extern int ind_endif;
extern int ind_else;
extern int ind_then;
extern int ind_bloque;
extern int ind_endwhile;
/* Pila */
extern info_elemento_pila pila_bloques[MAX_ANIDAMIENTOS];
extern int ult_pos_pila_bloques;

#endif
