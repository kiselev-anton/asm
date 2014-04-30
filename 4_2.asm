.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

len equ 5

.data
	ar1 dw 10,22,13,34,45
	ar2 db len dup (?)

.code
main:
	mov esi, offset ar1
	mov edi, offset ar2
	xor eax, eax
	xor ebx, ebx
	mov bx, 10
	mov ecx, len
	@cycle:
	xor edx, edx
	mov ax, [esi]
	div bx
	mov [edi], dl
	add esi, type ar1
	add edi, type ar2
	loop @cycle
	call exit
end main

