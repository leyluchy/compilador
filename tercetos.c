#include <stdio.h>
#include <stdlib.h>
#include "tercetos.h"
#include "y.tab.h"

/** Agrega un terceto a la lista de tercetos. Si se quiere guardar solo una constante o variable, mandar NOOP en
el campo de operador y op2. Para los operadores pasar el token literal, para los operandos pasar la posicion en
tabla de simbolos o el indice de otro terceto. */
int crear_terceto(int operador, int op1, int op2){
	ultimo_terceto++;
	if(ultimo_terceto >= MAX_TERCETOS){
		printf("Error: me quede sin espacio en para los tercetos. Optimiza tu codigo.\n");
		system("Pause");
		exit(3);
	}

	lista_terceto[ultimo_terceto].operador = operador;
	lista_terceto[ultimo_terceto].op1 = op1;
	lista_terceto[ultimo_terceto].op2 = op2;
	return ultimo_terceto + OFFSET;
}

/** Modifica el terceto con el indice indicado en la posicion indicada. El indice debe ser sin el OFFSET
y la posicion debe ser OP1, OP2 u OPERADOR. Si el terceto no existe, aborta la compilacion. */
void modificarTerceto(int indice, int posicion, int valor){
	if(indice > ultimo_terceto){
		printf("Ups, algo fallo. Intente modificar un terceto que no existe. Mala mia.");
		system ("Pause");
		exit (4);
	}
	switch(posicion){
	case OP1:
		lista_terceto[indice].op1 = valor;
		break;
	case OP2:
		lista_terceto[indice].op2 = valor;
		break;
	case OPERADOR:
		lista_terceto[indice].operador = valor;
		break;
	}
}

/* Guarda los tercetos generados en un archivo */
void guardarTercetos(){
	if(ultimo_terceto == -1)
		yyerror("No encontre los tercetos");

	FILE* arch = fopen("intermedia.txt", "w+");
	if(!arch){
		printf("No pude crear el archivo intermedia.txt\n");
		return;
	}

	for(int i = 0; i <= ultimo_terceto; i++){
		//La forma es [i] (operador, op1, op2)
		//Escribo indice
		fprintf(arch, "[%d] (", i + OFFSET);

		//escribo operador
		switch(lista_terceto[i].operador){
		case NOOP:
			fprintf(arch, "---");
			break;
		case BLOQ:
			fprintf(arch, "sentencia");
			break;
		case START:
			fprintf(arch, "start");
			break;
		case ID:
			fprintf(arch, "declaracion");
			break;
		case IF:
			fprintf(arch, "if");
			break;
		case THEN:
			fprintf(arch, "cuerpoIf");
			break;
		case WHILE:
			fprintf(arch, "while");
			break;
		case ASIG:
			fprintf(arch, "<-");
			break;
		case MAS:
			fprintf(arch, "+");
			break;
		case MENOS:
			fprintf(arch, "-");
			break;
		case POR:
			fprintf(arch, "*");
			break;
		case DIVIDIDO:
			fprintf(arch, "/");
			break;
		case AND:
			fprintf(arch, "y");
			break;
		case OR:
			fprintf(arch, "o");
			break;
		case NOT:
			fprintf(arch, "no");
			break;
		case MENOR:
			fprintf(arch, "<");
			break;
		case MAYOR:
			fprintf(arch, ">");
			break;
		case MENOR_IGUAL:
			fprintf(arch, "<=");
			break;
		case MAYOR_IGUAL:
			fprintf(arch, ">=");
			break;
		case IGUAL:
			fprintf(arch, "==");
			break;
		case DISTINTO:
			fprintf(arch, "=/=");
			break;
		case AVG:
			fprintf(arch, "avg");
			break;
		case INLIST:
			fprintf(arch, "inlist");
			break;
		case COMA:
			fprintf(arch, "\',\'");
			break;
		case PUNTO_COMA:
			fprintf(arch, "\';\'");
			break;
		case READ:
			fprintf(arch, "leeme");
			break;
		case WRITE:
			fprintf(arch, "mostrame");
			break;
		case CMP:
			fprintf(arch, "CMP");
			break;
		case BNE:
			fprintf(arch, "BNE");
			break;
		case BEQ:
			fprintf(arch, "BEQ");
			break;
		case BGT:
			fprintf(arch, "BGT");
			break;
		case BGE:
			fprintf(arch, "BGE");
			break;
		case BLE:
			fprintf(arch, "BLE");
			break;
		case BLT:
			fprintf(arch, "BLT");
			break;
		default:
			fprintf(arch, "algo esta mal");
			break;
		}

		fprintf(arch, ", ");
		//Escribo op1
		int op = lista_terceto[i].op1;

		if(op == NOOP)
			fprintf(arch, "---");
		else if(op < TAMANIO_TABLA){
			//Es una entrada a tabla de simbolos
			fprintf(arch, "%s", &(tabla_simbolo[op].nombre) );
		}
		else //Es el indice de otro terceto
			fprintf(arch, "[%d]", op);

		fprintf(arch, ", ");
		//Escribo op2
		op = lista_terceto[i].op2;
		if(op == NOOP)
			fprintf(arch, "---");
		else if(op < TAMANIO_TABLA){
			//Es una entrada a tabla de simbolos
			fprintf(arch, "%s", &(tabla_simbolo[op].nombre) );
		}
		else //Es el indice de otro terceto
			fprintf(arch, "[%d]", op);

		fprintf(arch, ")\n");
	}
	fclose(arch);
}
