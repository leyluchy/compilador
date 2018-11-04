#include <stdio.h>
#include "assembler.h"
#include "../y.tab.h"

void generarAssembler(){
  FILE* arch = fopen("final.asm", "w");
  if(!arch){
		printf("No pude crear el archivo final.txt\n");
		return;
	}

  escribirInicio(arch);
  generarTabla(arch);

  for(int i=0; i <= ultimo_terceto; i++){
    switch(lista_terceto[i].operador){
      case ASIG:
        break;
      case CMP:
        break;

      case BGT:
        break;
      case BGE:
        break;
      case BLT:
        break;
      case BLE:
        break;
      case BNE:
        break;
      case BEQ:
        break;
      case JMP:
        break;

      case THEN:
        escribirEtiqueta(arch, "then", i);
        break;
      case ELSE:
        escribirEtiqueta(arch, "else", i);
        break;
      case ENDIF:
        escribirEtiqueta(arch, "endif", i);
        break;

      case WHILE:
        escribirEtiqueta(arch, "while", i);
        break;
      case ENDWHILE:
        escribirEtiqueta(arch, "endwhile", i);
        break;

      case MAS:
        break;
      case MENOS:
        break;
      case POR:
        break;
      case DIVIDIDO:
        break;

      case READ:
        break;
      case WRITE:
        break;
    }
  }

  escribirFinal(arch);
  fclose(arch);

}

void escribirInicio(FILE *arch){
  fprintf(arch, "include macros2.asm\ninclude number.asm\n\n.MODEL SMALL\n.386\n.STACK 200h\n\n");
}

void escribirFinal(FILE *arch){
    fprintf(arch, "\nend\n");
}

void generarTabla(FILE *arch){
    fprintf(arch, ".DATA\n");

    for(int i=0; i<=fin_tabla; i++){
        fprintf(arch, "_%s dd ", tabla_simbolo[i].nombre);
        switch(tabla_simbolo[i].tipo_dato){
        case CteInt:
            fprintf(arch, "%d\n", tabla_simbolo[i].valor_i);
            break;
        case CteFloat:
            fprintf(arch, "%f\n", tabla_simbolo[i].valor_f);
            break;
        case CteString:
            fprintf(arch, "%s\n", tabla_simbolo[i].valor_s);
            break;
        default: //Es una variable
            fprintf(arch, "?\n");
        }
    }

    fprintf(arch, "\n");
}

void escribirEtiqueta(FILE* arch, char* etiqueta, int n){
    fprintf(arch, "%s%d: ", etiqueta, n);
}
