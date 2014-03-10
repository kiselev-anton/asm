.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
	a dd -2
	b dd 3
	cc dd 1
	d dd 10
	res dd ?

.code
	main:
						; a*b - c mod d
		mov eax, a
		imul b 			;a*b in edx:eax, edx could be full of F
		mov ecx, eax 	;result to ecx, eax is free
		mov eax, cc		;cc in eax
		cdq
		idiv d 		; mod in edx
		sub ecx, edx
		mov res, ecx
	end main