.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

len equ 5

.data
	ar1 dw 10,22,13,34,45
	ar2 dw ?,?,?,?,?

.code
main:
	mov esi, offset ar1
	mov edi, offset ar2
	add edi, len
	add edi, 2
	mov ecx, len
	@cycle:
	mov ax, [esi]
	mov [edi], ax
	add esi, type ar1
	sub edi, type ar2
	loop @cycle
	call exit
end main

