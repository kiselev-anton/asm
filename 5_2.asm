.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

len equ 4

.data
	arr dd 2, 207, 154, 98

.code
main:
	mov ecx, len
	dec ecx
	mov esi, offset arr
	@adding:				;# Trying to reach end of array.
	add esi, type arr
	loop @adding
	mov ecx, len
	dec ecx
	@sorting:
	call @max   ;# current element in [esi], max in [eax]
	mov ebx, [esi]
	mov edx, [eax]
	mov [esi], edx
	mov [eax], ebx
	loop @sorting

	call exit

@max:
;# ----------
;# Input:
;#    esi - address of ...
;#    eax - length
;# Output:
;#    ....
;# Returns address of the max element in: eax
;# End of the array: esi
;# Length of the array: ecx
;# Using: eax, ebx
	push ecx
	push ebx
	push edi
	push edx
	push esi
	mov eax, esi ;# Assuming maximum in eax.
	@cycle:
	sub esi, type arr
	mov ebx, esi
	mov edi, [eax]
	mov edx, [ebx]
	cmp edi, edx
	ja @first
	jmp @second
	@first: ;# eax is bigger
	loop @cycle
	jmp @ending
	@second:
	mov eax, ebx
	loop @cycle
	@ending:
	pop esi
	pop edx
	pop edi
	pop ebx
	pop ecx
	ret
end main

