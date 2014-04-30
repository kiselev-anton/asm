.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

len equ 5

.data
	ar1 dd -10,12,-13,34,45
	ar2 dd ?,?,?,?,?
	k dd 5

.code
main:
	mov esi, offset ar1
	sub esi, type ar1
	mov edi, offset ar2
	mov ecx, len
	@cycle:
	add esi, type ar1
	xor edx, edx
	mov eax, [esi]
	mov ebx, k
	cdq
	idiv ebx
	cmp ecx, 0
	jz @end
	dec ecx
	cmp edx, 0
	jnz @cycle
	mov eax, [esi]
	mov [edi], eax
	add edi, type ar2
	jmp @cycle
	@end:
	call exit
end main

