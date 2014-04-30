.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a dd 1024
	b dd 256
	gcd dd ?

.code
main:
	mov eax, a
	mov ebx, b
	@while:
	test ebx, ebx ; testing for b=0
	jz @end
	mov ecx, eax  ; saving eax in ecx
	xor edx, edx  ; cleaning edx
	div ebx		  ; eax / ebx
	mov eax, ebx  ; a = b
	mov ebx, edx  ; b = a%b
	jmp @while
	@end:
	mov gcd, eax
	call exit
end main
