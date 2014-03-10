.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a dd -11
	b dd -3
	res dd ?
.code
	main:
		xor edx, edx
		mov eax, a
		cdq
		idiv b
		mov res, edx
	end main

; положительное на отрицательное - остаток положителен
; отрицательное на положительное - остаток отрицателен
; отрицательное на отрицательное - остаток отрицателен