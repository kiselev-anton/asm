.486
.MODEL FLAT, STDCALL

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.DATA
  n db 0
  f dd ?
.CODE
main: 
  xor ebx, ebx        ;# cleaning the eax
  mov bl, n
  call @fact
  mov f, eax
  
  call exit

;# Factorial of n
;# Registers version
;# Input:
;#   ebx - n, 0 ≤ n ≤ 12
;# Output:
;#   eax - n!
@fact:
  push edx
  mov eax, 1
  jmp @fact_handling

@fact_handling:
  
  ;# base of recursion
  cmp ebx, 1
  je @stop_fact
  cmp ebx, 0
  je @stop_fact_0

  ;# calculations
  xor edx, edx
  mul dword ptr ebx

  ;# step of recursion
  dec ebx
  call @fact_handling

@stop_fact:
  pop edx
  ret
@stop_fact_0:
  pop edx
  mov eax, 1
  ret



END main







