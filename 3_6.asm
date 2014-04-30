.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	n db 4
	d dd ?
.code
main:
	xor ecx, ecx
	mov al, n
	dec al
	mov cl, al
	mov eax, 1
	mov ebx, 1
	@fib:
	mov edx, eax
	add eax, ebx
	mov ebx, edx
	loop @fib
	mov d, eax
	call exit
end main

