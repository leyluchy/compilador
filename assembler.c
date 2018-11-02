#include <stdio.h>
#include "assembler.h"
#include "y.tab.h"

void generarAssembler(){
  FILE* arch = fopen("final.asm", "w");
  if(!arch){
		printf("No pude crear el archivo final.txt\n");
		return;
	}

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
