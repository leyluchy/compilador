#ifndef tabla_simbolos_h
#define tabla_simbolos_h

/* Tipos de datos para la tabla de simbolos */
#define sinTipo 0
#define Int 1
#define Float 2
#define String 3
#define CteInt 4
#define CteFloat 5
#define CteString 6

#define TAMANIO_TABLA 256
#define TAM_NOMBRE 32

/* Funciones */
void agregarVarATabla(char* nombre);
void agregarTiposDatosATabla(void);
int agregarCteStringATabla(char* nombre);
int agregarCteIntATabla(int valor);
int agregarCteFloatATabla(float valor);

int chequearVarEnTabla(char* nombre);
int buscarEnTabla(char * name);
void escribirNombreEnTabla(char* nombre, int pos);
void guardarTabla(void);

int yyerror(char* mensaje);

typedef struct {
  char nombre[TAM_NOMBRE];
  int tipo_dato;
  char valor_s[TAM_NOMBRE];
  float valor_f;
  int valor_i;
  int longitud;
} simbolo;

/* Variables externas */
extern simbolo tabla_simbolo[TAMANIO_TABLA];
extern int fin_tabla; /* Apunta al ultimo registro en la tabla de simbolos. Incrementarlo para guardar el siguiente. */
extern int varADeclarar1;
extern int cantVarsADeclarar;
extern int tipoDatoADeclarar;

#endif
