.486
.MODEL FLAT, STDCALL

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.DATA
  scan_format db "%d", 0
  print_format db 13, 10, "Result: %d+10=%d", 13, 10, 0
  n dd ? ;# место для переменной ввода
.CODE
main: 
;#  считываем число
  push offset n
  push offset scan_format
  call scanf
  add esp, 8 ;# оно кладется на вершину стека
  
;# арифметика 
  mov eax, n
  add eax, 10
;# вывод
  push eax
  push n
  push offset print_format
  call printf
  add esp, 12
  
  call getch
  call getch
  
  call exit
  
END main







