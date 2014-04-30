.486
.model flat, stdcall

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.data

pascal_array1 dd 1, 19 dup (0)		;# two arrays for previous and current
pascal_array2 dd 20 dup (0)			;#  states of the triangle
scan_format db "%d", 0
print_format db "%d ", 0
newline db 13, 10, 0
n dd ?

.code

@pascal_print:
	;# prints new line
	;# [esp+8] - current line
	push ebp
	mov ebp, esp
	push ecx

	mov [pascal_array2], 1  	;# adding 1 in the beginning
	xor ecx, ecx
	mov esi, [esp+12]
	cmp esi, 2   		;# special case for n=2
	jz @skip
	@creating:
	mov eax, [pascal_array1+ecx*4]
	mov ebx, [pascal_array1+ecx*4+4]
	mov edx, eax
	add edx, ebx 						;# sum of number from previous line
	mov [pascal_array2+ecx*4+4], edx
	inc ecx
	cmp ecx, [esp+12]
	jnz @creating
	jmp @begin
	@skip:
	mov [pascal_array2+ecx*4+4], 1
	jmp @begin
	mov [pascal_array2+ecx*4+8], 1  		;# adding 1 in the end

	@begin:
	mov ecx, [esp+12]
	@printing:			;# prints current line
	push ecx
	push [pascal_array2+ecx*4-4]
	push offset print_format
	call printf
	add esp, 8
	pop ecx
	loop @printing
	push offset newline
	call printf
	add esp, 4

	mov ecx, [esp+12]
	@copying:					;# saves current line as old line
	mov eax, [pascal_array2+ecx*4-4]
	mov [pascal_array1+ecx*4-4], eax
	loop @copying

	pop ecx
	pop ebp
ret

main:
	push offset n
	push offset scan_format		;# reading number of lines
	call scanf
	add esp, 8

	push offset newline		;# printing newline char
	call printf
	add esp, 4

	push 1
	push offset print_format		;# printing first line
	call printf
	sub esp, 8

	push offset newline		;# printing newline char yet again
	call printf
	add esp, 4

	inc n 
	inc n			;# some crutches here

	mov ecx, n
	sub ecx, 2
	cmp ecx, 0
	jz @exit
	@print:				;# for i=2 to n
	mov eax, n
	sub eax, ecx	;# current line number
	push eax
	call @pascal_print		;# printing it
	loop @print

	@exit:
	call exit

end main
