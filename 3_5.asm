.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	n db 5
	d dd ?
.code
main:
	xor ecx, ecx
	mov cl, n
	mov eax, 1
	@fact:
	mul cl
	loop @fact
	mov d, eax
	call exit
end main

