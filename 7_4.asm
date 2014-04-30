.486
.MODEL FLAT, STDCALL

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.DATA
  scan_format db "%d %d", 0
  print_format db 13, 10, "Result: gcd(%d,%d)=%d", 13, 10, 0
  m dd ? ;# место для первой переменной ввода
  n dd ? ;# и второй

.CODE

@gcd:
;# --------------
;# Calculates greater common divisor
;# Numbers in: eax, ebx Number signed.
;# Result in: eax
;# Saving: edx

  push edx
  @while:
  test ebx, ebx ; testing for b=0
  jz @end
  cdq
  idiv ebx      ; eax / ebx
  mov eax, ebx  ; a = b
  mov ebx, edx  ; b = a%b
  jmp @while
  @end:
  pop edx
  ret

main: 
;#  считываем числа
  push offset n
  push offset m
  push offset scan_format
  call scanf
  add esp, 12 ;# оно кладется на вершину стека
  
;# арифметика
  mov eax, m
  mov ebx, n
  call @gcd
;# вывод
  push eax
  push n
  push m
  push offset print_format
  call printf
  add esp, 16
  
  call getch
  call getch
  
  call exit
  
END main









