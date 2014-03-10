.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
    a dd 1378
    b dd 425
    d dd 16
    e dd ?
    
.code
    main:
        mov eax, a
        mov ebx, b
        mul ebx ;result is in edx eax
        sub eax, d
        mov e, eax
    end main