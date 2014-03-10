.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a dw 2

.code
	main:
		mov ax, a
		not ax
		inc ax
		mov a, ax
	end main