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
 			fprintf(arch,"case ASIG:");

      break;
      case CMP:
 			fprintf(arch,"case CMP:");
      break;

      case BGT:
 			fprintf(arch,"case BGT:");
      break;
      case BGE:
 			fprintf(arch,"case BGE:");
      break;
      case BLT:
 			fprintf(arch,"case BLT:");
      break;
      case BLE:
 			fprintf(arch,"case BLE:");
      break;
      case BNE:
 			fprintf(arch,"case BNE:");
      break;
      case BEQ:
 			fprintf(arch,"case BEQ:");
      break;
      case JMP:
 			fprintf(arch,"case JMP:");
      break;

      case THEN:
 			fprintf(arch,"case THEN:");
      break;
      case ELSE:
 			fprintf(arch,"case ELSE:");
      break;
      case ENDIF:
 			fprintf(arch,"case ENDIF:");
      break;

      case WHILE:
 			fprintf(arch,"case WHILE:");
      break;
      case ENDWHILE:
 			fprintf(arch,"case ENDWHILE:");
      break;

      case MAS:
 			fprintf(arch,"case MAS:");
      break;
      case MENOS:
 			fprintf(arch,"case MENOS:");
      break;
      case POR:
 			fprintf(arch,"case POR:");
      break;
      case DIVIDIDO:
 			fprintf(arch,"case DIVIDIDO:");
      break;

      case READ:
 			fprintf(arch,"case READ:");
      break;
      case WRITE:
 			fprintf(arch,"case WRITE:");
      break;
    }
  }

  fclose(arch);

}

void escribirInicio(FILE *arch){
  fprintf(arch, "include macros2.asm\ninclude number.asm\n\n.MODEL SMALL\n.386\n.STACK 200h\n");
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
}
