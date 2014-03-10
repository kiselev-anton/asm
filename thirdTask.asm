.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
    a dd 0a0000000h
    b dd 0
.code

main:
    ; first part
    mov eax, a
    add eax, eax
    mov a, eax
    ;second part
    mov eax, b
    sub eax, 1
    mov b, eax
end main