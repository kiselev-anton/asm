.486
.MODEL Flat, StdCall

INCLUDE stdlib.inc
INCLUDE stdio.inc
INCLUDELIB msvcrt.lib

.CODE

main:
    mov eax, 1
    mov ebx, 2
    add eax, ebx
    call exit
end main
