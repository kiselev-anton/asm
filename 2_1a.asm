.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a db 2

.code
	main:
		mov al, a
		not al
		inc al
		mov a, al
	end main