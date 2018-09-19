c:\GnuWin32\bin\flex lexico.l
pause
c:\GnuWin32\bin\bison -dyv Sintactico.y
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o Primera.exe
pause

Primera.exe pruebas.txt
pause

del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
pause