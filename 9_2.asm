.486
.model flat, stdcall

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.data
	a dq ?
	b dq ?
	scan_format db "%lf %lf", 0 
	print_format db "max = %lf, min = %lf", 13, 10

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
	fcompp
	fstsw ax
	sahf

	jb @smaller
	mov esi, offset a 	;# b > a
	push [esi+4]
	push [esi]
	mov esi, offset b
	push [esi+4]
	push [esi]
	push offset print_format
	call printf
	jmp @end

	@smaller:
	mov esi, offset b 			;# a > b
	push [esi+4]
	push [esi]
	mov esi, offset a
	push [esi+4]
	push [esi]
	push offset print_format
	call printf

	@end:
	call exit


end main
