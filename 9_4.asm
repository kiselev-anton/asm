.486
.model flat, stdcall

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.data
	n dd ?
	solution dq ?
	scan_format db "%d", 0 
	print_format db "sum = %lf", 13, 10

.code

main:
	push offset n		;# reading value of n
	push offset scan_format
	call scanf
	add esp, 8

	finit
	fldz
	mov ecx, n
	@addition:		;# performing arithmetics
	mov n, ecx
	fild n
	fild n
	fmulp st(1), st(0)
	fld1
	fdivr
	faddp st(1), st(0)
	loop @addition
	fst solution

	mov esi, offset solution  ;# outputing answer
	push [esi+4]
	push [esi]
	push offset print_format
	call printf

	call exit


end main
