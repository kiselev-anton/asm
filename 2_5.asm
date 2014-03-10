.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a dw 43
	m dw 1

.code
	main:
		xor eax, eax
		mov ax, a
		and ax, m
	end main