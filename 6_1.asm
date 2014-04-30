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
  call @fact
  add esp, 4
  mov f, eax
  
  call exit

;# Factorial of n
;# Stack version
;# Input:
;#   [ebp+8] - n, 0 ≤ n ≤ 12
;# Output:
;#   eax - n!

@fact:
  ;# stack handling
  push ebp
  mov ebp, esp
  push edx

  ;# base of recursion
  mov eax, [ebp+8]
  cmp eax, 1
  je @stop_fact
  ;# special case for 0!
  cmp eax, 0
  je @stop_fact_0

  ;# step of recursion
  dec eax
  push eax
  call @fact
  add esp, 4

  ;# calculations
  xor edx, edx
  mul dword ptr [ebp+8]

@stop_fact:
  pop edx
  pop ebp
  ret

@stop_fact_0:
  mov eax, 1
  pop edx
  pop ebp
  ret



END main







