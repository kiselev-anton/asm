.486
.MODEL FLAT, STDCALL

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.DATA
  mess db "Hello, world!", 13, 10, 0
  
.CODE
main:    ; точка входа программы
  push offset mess
  call printf
  
  call exit
END main