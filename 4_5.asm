.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

len equ 5

.data
	ar1 dd 10,22,-17,34,45
	ar2 dd -2, 5, 9, 4, 3
	ar3 dd len dup (?)
	pr dd ?
.code
main:
	mov esi, offset ar1
	mov edi, offset ar2
	mov ebp, offset ar3
	mov ecx, len
	@sum:
	mov eax, [esi]
	add eax, [edi]
	mov [ebp], eax
	add esi, type ar1
	add edi, type ar2
	add ebp, type ar3
	loop @sum
	mov esi, offset ar1
	mov edi, offset ar2
	mov ecx, len
	xor eax, eax
	mov eax, 1
	@scalarPr:
	mov eax, [esi]
	mov ebx, [edi]
	mul ebx
	add edx, eax
	add edx, pr
	mov pr, edx
	add esi, type ar1
	add edi, type ar2
	loop @scalarPr
	mov pr, eax
	call exit
end main

