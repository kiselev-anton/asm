.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a dd 16
	m dd 055555555h
.code
	main:
		mov eax, a
		mov ebx, m
		and eax, ebx
	end main