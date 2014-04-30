.486
.model flat, stdcall

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.data
	four dd 4
	two dd 2
	a dq ?
	b dq ?
	d dq ?
	dis dq ?
	solution1 dq ?
	solution2 dq ?
	scan_format db "%lf %lf %lf", 0
	print_format1 db 13, 10, "x1 = %lf, x2 = %lf", 13, 10, 0 ;# x=-(b+-sqrt(D))/a
	print_format2 db 13, 10, "Complex roots, can't compute, too dumb ;(", 13, 10, 0
	print_format3 db 13, 10, "x = %lf", 13, 10, 0  ;# x = -b/2a

.code

main:
	push offset d
	push offset b
	push offset a
	push offset scan_format
	call scanf 				;# scanning a, b, c
	add esp, 16

	finit
	fld qword ptr b
	fmul st(0), st(0)  ;# b^2
	fld qword ptr a ;# a*c
	fld qword ptr d 
	fmulp st(1), st(0)
	fild four
	fmulp st(1), st(0)	;# 4*a*c
	fsub   ;# b^2-4*a*c=D - on top of the stack
	fldz
	fcomp  ;# comparing D with 0
	fstsw ax
	sahf

	jb @two_roots
	jz @one_root
	
	push offset print_format2	;# D < 0 => complex numbers
	call printf
	add esp, 4
	jmp @end

	@one_root:		;# x = -b / 2a
	fld qword ptr a
	fild two
	fmulp st(1), st(0)
	fld qword ptr b
	fchs
	fdivr
	fst solution1

	mov esi, offset solution1
	push [esi+4]
	push [esi]
	push offset print_format3
	call printf
	add esp, 12

	jmp @end

	@two_roots:	;# x=-(b+-sqrt(D))/a
	fst qword ptr dis
	fsqrt
	fld qword ptr a
	fild two
	fmulp st(1), st(0)
	fdiv

	fld qword ptr b
	fchs
	fild two
	fld qword ptr a
	fmulp st(1), st(0)
	fdivp st(1), st(0)

	faddp st(1), st(0)
	fst solution1

	fld qword ptr dis
	fsqrt
	fld qword ptr a
	fild two
	fmulp st(1), st(0)
	fdiv

	fld qword ptr b
	fchs
	fild two
	fld qword ptr a
	fmulp st(1), st(0)
	fdivp st(1), st(0)

	fsubr
	fst solution2

	mov esi, offset solution1
	push [esi+4]
	push [esi]
	mov esi, offset solution2
	push [esi+4]
	push [esi]
	push offset print_format1
	call printf
	add esp, 20

	@end:
	call exit


end main
