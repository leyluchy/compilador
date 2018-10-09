# Compilador
Este proyecto es para la materia Lenguajes y Compiladores de la UNLaM.

## Preparar algunas cosas
Es necesario tener Flex y Bison para C instalados, y el compilador de C MinGW. Los tres se pueden descargar de https://sites.google.com/view/lycunlam/compilador/herramientas
Además hay que agregar los path de los tres a las variables de entorno del sistema.

La compilación la hacemos mediante un archivo .bat. Este archivo asume que Flex y Bison se encuentran en el path c:\GnuWin32\bin\ y que el compilador se encuentra en c:\MinGW\bin\

## Lenguaje Ñ
En este proyecto estamos creando un compilador para el lenguaje Ñ, que es un lenguaje inventado por nosotros para la materua Lenguajes y Compiladores de la carrera de Ingeniería en Informática en la UNLaM.
En el archivo LEL.txt se detalla qué palabra reservada corresponde a qué token.

# Implementar chequeo de tipo de datos
Chequear tipo de dato por asignacion, cuando leemos cte int, cte float e id.
Cosas que requieren el mismo tipo de dato internamente pero son independiente de lo de afuera:
- Asignacion
- Termino logico
- Average?
- Sentencia es expresion_aritmetica PUNTO_COMA
