.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a dd 352
	b dd 1328
	d dd ?

.code
	main:
		mov eax, a
		cmp eax, b
		jge l1 ; a > b
		mov eax, b
		mov d, eax
		jmp e
		l1:
		mov d, eax
		e: ;end of programm
		call exit
	end main

