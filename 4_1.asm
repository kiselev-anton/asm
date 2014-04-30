.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

len equ 5

.data
	arr dw 1,2,3,4,5
	sum dw ?
	prod dw ?


.code
main:
	mov esi, offset arr
	xor ebx, ebx
	mov ecx, len
	@sum:
	xor eax, eax
	mov ax, [esi]
	add bx, ax
	add esi, type arr
	loop @sum
	mov sum, bx
	mov esi, offset arr
	mov ecx, len
	xor eax, eax
	xor ebx, ebx
	mov eax, 1
	@prod:
	mul word ptr [esi]
	add esi, type arr
	loop @prod
	mov prod, ax
	call exit
end main

