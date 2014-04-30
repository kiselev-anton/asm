.486
.MODEL FLAT, STDCALL

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

;# len equ 4

.DATA
  len dd 4
  arr dd 9, 5, 2, 1 ;# unsigned
  a dd -1            ;# минимум
  b dd -1            ;# его адрес

.CODE
main: 
  push offset b
  push offset a
  push offset arr
  push len
  call @minimum

  add esp, 16
  call exit

@minimum:
  ;# --------------------
  ;# Finds minimum in array, returns it's value and address
  ;# Input:
  ;#  [ebp+8+8] - array length
  ;#  [ebp+12+8] - array address
  ;#  [ebp+16+8] - where to put min value
  ;#  [ebp+20+8] - where to put it's address in array
  ;# Local variables:
  ;#  [ebp-4] - current min value
  ;#  [ebp-8] - current min address 
  ;# Output:
  ;#  a - min value
  ;#  b - it's address

  ;# saving stack state
  push ebp
  sub esp, 8  ;# local variables
  mov ebp, esp

  ;# saving current state
  push ecx
  push esi
  push eax
  push ebx

  ;# assuming min in first element
  mov esi, [ebp+20] ;# array address in esi
  mov eax, [esi]
  mov dword ptr [ebp-4], eax
  mov dword ptr [ebp-8], esi

  ;# search
  mov ecx, [ebp+16]
  @for:
  mov eax, [esi]
  cmp eax, [ebp-4]
  ja @bigger
  mov [ebp-4], eax  ;# new min has been found
  mov [ebp-8], esi
  @bigger:
  add esi, 4
  loop @for

  ;# returning result
  mov eax, [ebp-4]
  mov esi, [ebp-8]
  mov ecx, ebp
  add ecx, 24
  mov ebx, [ecx]
  mov dword ptr [ebx], eax
  add ecx, 4
  mov ebx, [ecx]
  mov dword ptr [ebx], esi

  ;# restoring state
  pop ebx
  pop eax
  pop esi
  pop ecx
  ;# restoring stack state
  add esp, 8
  pop ebp

  ret

END main







