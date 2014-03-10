.486
.MODEL Flat, StdCall

INCLUDE stdlib.inc
INCLUDELIB msvcrt.lib

.data
    a dd 20
    b dd 5
    
.code

 main:
    ;multiply a and b
    mov ebx, a
    mov eax, b
    mul ebx ;it writes to eax
    ;division by 17
    mov edx, 
    mov ebx, 17
    div ebx
end main
