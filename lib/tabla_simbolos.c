#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabla_simbolos.h"

//Variable de control de nombres para las String
int contadorString=0;

/** Agrega un nuevo nombre de variable a la tabla **/
void agregarVarATabla(char* nombre){
 //Si se llena, error
 if(fin_tabla >= TAMANIO_TABLA - 1){
	 printf("Error: me quede sin espacio en la tabla de simbolos. Sori, gordi.\n");
	 system("Pause");
	 exit(2);
 }
 //Si no hay otra variable con el mismo nombre...
 if(buscarEnTabla(nombre) == -1){
	 //Agregar a tabla
	 fin_tabla++;
	 escribirNombreEnTabla(nombre, fin_tabla);
 }
 else yyerror("Encontre dos declaraciones de variables con el mismo nombre. Decidite."); //Error, ya existe esa variable
}

/** Si la variable ya existe, devuelve la posicion. Si no, agrega un nuevo
* nombre de variable y tipo a la tabla y devuelve la posicion donde la agrego
*/
int agregarVarATabla2(char* nombre, int tipo){
 //Si se llena, error
 if(fin_tabla >= TAMANIO_TABLA - 1){
	 printf("Error: me quede sin espacio en la tabla de simbolos. Sori, gordi.\n");
	 system("Pause");
	 exit(2);
 }

 int pos = buscarEnTabla(nombre);
 //Si no hay otra variable con el mismo nombre...
 if(pos == -1){
	 //Agregar a tabla
	 fin_tabla++;
	 escribirNombreEnTabla(nombre, fin_tabla);
   tabla_simbolo[fin_tabla].tipo_dato = tipo;
   return fin_tabla;
 }
 return pos;
}

/** Agrega los tipos de datos a las variables declaradas. Usa las variables globales varADeclarar1, cantVarsADeclarar y tipoDatoADeclarar */
void agregarTiposDatosATabla(){
	for(int i = 0; i < cantVarsADeclarar; i++){
		tabla_simbolo[varADeclarar1 + i].tipo_dato = tipoDatoADeclarar;
	}
}

/** Agrega una constante string a la tabla de simbolos */
int agregarCteStringATabla(char* nombre){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		printf("Error: me quede sin espacio en la tabla de simbolos. Sori, gordi.\n");
		system("Pause");
		exit(2);
	}

	//Preparo el nombre. Nuestras constantes empiezan con _ en la tabla de simbolos
	//sprintf(nuevoNombre, "_%s", nombre); OLD
	int pos=buscarStringEnTabla(nombre);
	//int pos=buscarEnTabla(nuevoNombre);
	//Si no hay otra constante string con el mismo contenido...
	if(pos == -1){
		//Agregar nombre a tabla
		fin_tabla++;
		char nuevoNombre[10]; //10 porque EL maximo tamaño que puede tener está dado por "StringXXX" mas el fin de linea
		sprintf(nuevoNombre, "String%d", contadorString);
		contadorString++;
		escribirNombreEnTabla(nuevoNombre, fin_tabla);

		//Agregar tipo de dato
		tabla_simbolo[fin_tabla].tipo_dato = CteString;

		//Agregar valor a la tabla
		strcpy(tabla_simbolo[fin_tabla].valor_s, nombre);

		//Agregar longitud
		tabla_simbolo[fin_tabla].longitud = strlen(nombre) - 1;

		pos=fin_tabla;
	}
	return pos;
}

/** Agrega una constante entera a la tabla de simbolos */
int agregarCteIntATabla(int valor){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		printf("Error: me quede sin espacio en la tabla de simbolos. Sori, gordi.\n");
		system("Pause");
		exit(2);
	}

	//Genero el nombre
	char nombre[30];
	sprintf(nombre, "_%d", valor);
	int pos=buscarEnTabla(nombre);

	//Si no hay otra variable con el mismo nombre...
	if(pos == -1){
		//Agregar nombre a tabla
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);

		//Agregar tipo de dato
		tabla_simbolo[fin_tabla].tipo_dato = CteInt;

		//Agregar valor a la tabla
		tabla_simbolo[fin_tabla].valor_i = valor;
		pos = fin_tabla;
	}
	return pos;
}

/** Agrega una constante real a la tabla de simbolos */
int agregarCteFloatATabla(float valor){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		printf("Error: me quede sin espacio en la tabla de simbolos. Sori, gordi.\n");
		system("Pause");
		exit(2);
	}

	//Genero el nombre
	char nombre[12];
	sprintf(nombre, "_%f", valor);
	int pos=buscarEnTabla(nombre);
	//Si no hay otra variable con el mismo nombre...
	if(pos == -1){
		//Agregar nombre a tabla
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);

		//Agregar tipo de dato
		tabla_simbolo[fin_tabla].tipo_dato = CteFloat;

		//Agregar valor a la tabla
		tabla_simbolo[fin_tabla].valor_f = valor;
		pos = fin_tabla;
	}
	return pos;
}

/** Se fija si ya existe una entrada con ese nombre en la tabla de simbolos.
Si no existe, muestra un error de variable sin declarar y aborta la compilacion.
Si existe, devuelve el tipo de dato de esa variable. */
int chequearVarEnTabla(char* nombre){
	int pos = buscarEnTabla(nombre);
	//Si no existe en la tabla, error
	if( pos == -1){
		char msg[100];
		sprintf(msg,"%s? No, man, tenes que declarar las variables arriba. Esto no es un viva la pepa como java...", nombre);
		yyerror(msg);
	}
	//Si existe en la tabla, devuelvo el tipo de dato
	return tabla_simbolo[pos].tipo_dato;
}

/* Devuleve la posici�n en la que se encuentra el elemento buscado, -1 si no encontr� el elemento */
int buscarEnTabla(char * name){
   int i=0;
   while(i<=fin_tabla){
	   if(strcmp(tabla_simbolo[i].nombre,name) == 0){
		   return i;
	   }
	   i++;
   }
   return -1;
}

/* Devuleve la posici�n en la que se encuentra el elemento String buscado, -1 si no encontr� el elemento */
int buscarStringEnTabla(char * name){
   int i=0;
   while(i<=fin_tabla){
	   if(tabla_simbolo[i].tipo_dato==6 && strcmp(tabla_simbolo[i].valor_s,name) == 0){
		   return i;
	   }
	   i++;
   }
   return -1;
}

/** Escribe el nombre de una variable o constante en la posición indicada */
void escribirNombreEnTabla(char* nombre, int pos){
	strcpy(tabla_simbolo[pos].nombre, nombre);
}

/** Guarda la tabla de simbolos en un archivo de texto */
void guardarTabla(){
	if(fin_tabla == -1)
		yyerror("No encontre la tabla de simbolos");

	FILE* arch = fopen("ts.txt", "w+");
	if(!arch){
		printf("No pude crear el archivo ts.txt\n");
		return;
	}

	for(int i = 0; i <= fin_tabla; i++){
		fprintf(arch, "%s\t", &(tabla_simbolo[i].nombre) );

		switch (tabla_simbolo[i].tipo_dato){
		case Float:
			fprintf(arch, "FLOAT");
			break;
		case Int:
			fprintf(arch, "INT");
			break;
		case String:
			fprintf(arch, "STRING");
			break;
		case CteFloat:
			fprintf(arch, "CTE_FLOAT\t%f", tabla_simbolo[i].valor_f);
			break;
		case CteInt:
			fprintf(arch, "CTE_INT\t%d", tabla_simbolo[i].valor_i);
			break;
		case CteString:
			fprintf(arch, "CTE_STRING\t%s\t%d", &(tabla_simbolo[i].valor_s), tabla_simbolo[i].longitud);
			break;
		}

		fprintf(arch, "\n");
	}
	fclose(arch);
}
