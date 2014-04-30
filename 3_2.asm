.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a dd 2017
	
.code
main:
	mov eax, a
	test eax, 1 ;ZF = 0 if even
	je @even
	xor edx, edx
	mov ebx, 3
	mul ebx
	inc eax
	jmp @e
	@even:
	mov cl, 1
	shr eax, cl
	@e:
	call exit
end main
