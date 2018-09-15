c:\GnuWin32\bin\flex lexico.l
pause
c:\GnuWin32\bin\bison -dyv Sintactico.y
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o lexico.exe
pause

lexico.exe pruebaSimple.txt
pause