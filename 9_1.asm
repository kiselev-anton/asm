.486
.model flat, stdcall

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.data
	a dq ?
	b dq ?
	solution dq ?
	scan_format db "%lf %lf", 0 
	print_format db "x = %lf", 13, 10 ;# x=-b/a

.code

main:
	push offset b
	push offset a
	push offset scan_format
	call scanf
	add esp, 12

	finit
	fld qword ptr a
	fld qword ptr b
	fdivr
	fchs
	fst solution

	mov esi, offset solution
	push [esi+4]
	push [esi]
	push offset print_format
	call printf

	call exit


end main
