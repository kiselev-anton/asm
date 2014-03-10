.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a dd 14
	b db 2

.code
	main:
		mov eax, a
		mov cl, b
		shr eax, cl
	end main