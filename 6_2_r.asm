.486
.MODEL FLAT, STDCALL

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.DATA
  n db 20
  f dd ?
.CODE
main: 
  xor ebx, ebx        ;# cleaning the eax
  mov bl, n
  call @fib
  mov f, eax
  
  call exit

;# Fibonacci number n
;# Registers version
;# Input:
;#   ebx - n, 0 ≤ n ≤ 42
;# Output:
;#   eax - Fib(n)
@fib:
  push edx
  mov eax, 1 ;# Fib(0)
  mov edx, 1 ;# Fib(1)
  jmp @fib_handling

@fib_handling:
  
  ;# base of recursion
  cmp ebx, 1
  je @stop_fib
  cmp ebx, 0
  je @stop_fib_0

  ;# calculations
  push ecx
  mov ecx, eax
  add eax, edx
  mov edx, ecx
  pop ecx

  ;# step of recursion
  dec ebx
  call @fib_handling

@stop_fib:
  pop edx
  ret
@stop_fib_0:
  pop edx
  ret



END main







