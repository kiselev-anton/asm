.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a dw 1600

.code
main:
	xor eax, eax ; cleaning the eax
	xor ebx, ebx ; same here for ebx
	xor edx, edx ; same for edx
 	mov ax, a
 	mov bx, 400 ; testing for /400
 	div bx
 	test dx, dx
 	jz @first1
 	jmp @second
 	@first1: ; testing for not/100
 	mov ax, a
 	mov bx, 100
 	xor edx, edx ; cleaning
 	div bx
 	test dx, dx
 	jnz @first2
 	jmp @third
 	@first2:  ;first case scenario
 	mov ax, 1
 	jmp @end
	@second: ; testing for /4
	mov ax, a
	mov bx, 4
	xor edx, edx ; cleaning
	div bx
	test dx, dx
	jz @first2
 	@third:  ; sad face ;(
 	mov ax, 0
 	@end:
 	call exit
 end main


