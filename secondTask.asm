.486
.MODEL Flat, StdCall

INCLUDE stdlib.inc
INCLUDELIB msvcrt.lib

.DATA
    a dd 1
    b dd 2
    d dd 42

.CODE

main:
    mov eax, a
    mov ebx, b
    add eax, ebx
    mov d, eax
    call exit
end main