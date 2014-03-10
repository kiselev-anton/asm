.486
.model Flat, StdCall

include stdlib.inc
includelib msvcrt.lib

.data
    a dd 9

.code
    main:
        ; test for 2
        mov eax, a
        mov ebx, 2
        mov edx, 0
        div ebx ; remainder in edx
        mov cl, dl

        ;test for 3
        mov eax, a
        mov ebx, 3
        mov edx, 0
        div ebx
        mov ah, dl
        mov al, cl
    end main
    