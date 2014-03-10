.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a dd 2

.code
	main:
		mov eax, a
		not eax
		inc eax
		mov a, eax
	end main