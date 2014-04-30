.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

len equ 4

.data
	arr dd 28, -70, 154, -98

.code
main:
	mov ecx, len
	dec ecx
	mov esi, offset arr
	@adding:				;# Trying to reach end of array.
	add esi, type arr
	loop @adding
	mov eax, [esi] 			;# First value.
	mov ecx, len
	dec ecx
	@cycle:
	;# We assume, that we have previous value in eax.
	sub esi, type arr
	mov ebx, [esi]
	call @gcd
	loop @cycle
	call exit

@gcd:
;# --------------
;# Calculates greater common divisor
;# Numbers in: eax, ebx Number signed.
;# Result in: eax
;# Saving: edx

	push edx
	@while:
	test ebx, ebx ; testing for b=0
	jz @end
	cdq
	idiv ebx		  ; eax / ebx
	mov eax, ebx  ; a = b
	mov ebx, edx  ; b = a%b
	jmp @while
	@end:
	pop edx
	ret

end main

