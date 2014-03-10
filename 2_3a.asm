.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a dd 2
	b dd 3
	cc dd 1
	d dd 10
	res dd ?

.code
	main:
		; a*b - c mod d
		mov eax, a
		mul b ;a*b in edx:eax
		mov ecx, eax ;eax is free
		mov eax, cc; cc in eax
		div d; mod in edx
		sub ecx, edx
		mov res, ecx
	end main