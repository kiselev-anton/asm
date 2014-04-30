.486
.MODEL FLAT, STDCALL

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.DATA
  n db 12
  f dd ?
.CODE
main: 
  xor eax, eax        ;# cleaning the eax
  mov al, n
  push eax
  call @fib
  add esp, 4
  mov f, eax
  
  call exit

;# Fibonacci number n
;# Stack version
;# Notes:
;#   – assuming Fib(0)=Fib(1)=1 
;# Input:
;#   [ebp+8] - n, 0 ≤ n ≤ 12
;# Output:
;#   eax - Fib(n)

@fib:
  ;# stack handling
  push ebp
  mov ebp, esp

  ;# base of recursion
  mov eax, [ebp+8]
  cmp eax, 1
  je @stop_fib
  ;# special case for 0
  cmp eax, 0
  je @stop_fib_0

  ;# step of recursion
  dec eax
  push eax
  call @fact
  add esp, 4

  ;# calculations
  xor edx, edx
  mul dword ptr [ebp+8]

@stop_fib:
  pop ebp
  ret

@stop_fib_0:
  mov eax, 1
  pop ebp
  ret



END main







