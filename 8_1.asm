.486
.model flat, stdcall

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.data
len dd 5
array dd 2,3,1,5,6

.code
@bubble_pop:
;# Single popping for bubble sort
;# Input:
;# [ebp+8] - length
;# [ebp+12] - array address
;# Using ebp, eax, ecx, ebx
	push ebp		;# stack handling
	mov ebp, esp
	mov esi, [ebp+12]	

	push eax			;# saving state
	push ebx
	push ecx

	mov ecx, [ebp+8]
	dec ecx
	@pop_for:				;# for i=1 to length
	mov eax, [esi+ecx*4]
	mov ebx, [esi+ecx*4-4]
	cmp eax, ebx			;# comparing values
	ja @end
	mov [esi+ecx*4-4], eax		;# swapping them if needed
	mov [esi+ecx*4], ebx
	@end:
	loop @pop_for

	pop ecx		;# restoring state
	pop ebx
	pop eax
	pop ebp
ret 


@bubble_sort:
;# Sorts array using bubble sorting algorithm. n^2 hardcoded
;# Input:
;# [ebp+4] - length of the array
;# [ebp+8] - array address
;# Output:
;# sorted array 
;# Using ebp, eax, ebx, ecx
	push ebp			;# stack handling
	mov ebp, esp
	mov esi, [ebp+12]

	push eax			;# saving state
	push ebx
	push ecx

	mov ecx, [ebp+8]
	dec ecx
	@bubble_for:				;# for i=1 to length
	push [ebp+12]
	push [ebp+8]
	call @bubble_pop		;# popping a bubble
	add esp, 8
	loop @bubble_for

	pop ecx
	pop ebx
	pop eax
	pop ebp
ret

main:
	push offset array
	push len
	call @bubble_sort		;# sorting array using bubble sort
	add esp, 8
	call exit

end main