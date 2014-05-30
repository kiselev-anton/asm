.486
.model flat, stdcall

include kernel32.inc
includelib kernel32.lib
include stdlib.inc
include stdio.inc
include msvcrt.inc
includelib msvcrt.lib

system proto c :dword ;# prototype for system calls

.data
int_to_str db "%4d", 0
dot db "   ." , 0
 tile1 db 8 dup (?), 0         ;# temp arrays for printing game state
 tile2 db 8 dup (?), 0
 tile3 db 8 dup (?), 0
 tile4 db 8 dup (?), 0
 tile5 db 8 dup (?), 0
 tile6 db 8 dup (?), 0
 tile7 db 8 dup (?), 0
 tile8 db 8 dup (?), 0
 tile9 db 8 dup (?), 0
tile10 db 8 dup (?), 0
tile11 db 8 dup (?), 0
tile12 db 8 dup (?), 0
tile13 db 8 dup (?), 0
tile14 db 8 dup (?), 0
tile15 db 8 dup (?), 0
tile16 db 8 dup (?), 0
tile_list dword tile1, tile2, tile3, tile4, tile5, tile6, tile7, tile8, tile9,
                tile10, tile11, tile12, tile13, tile14, tile15, tile16
                ;# arrays of pointers to temp arrays
free_tiles dd 16
score dd 0
step dd 1
game_over db "Game over. Your score: %d. Your steps: %d. ",
             "Good luck next time!", 13, 10, 0
game_win db "You win. Your score: %d. Your steps: %d.", 13, 10, 0
game_stats db "Your score: %d Current step: %d Free tiles: %d", 13, 10, 0
game_field db "#######################", 13, 10,
              "#                     #", 13, 10,
              "# %s %s %s %s #", 13, 10,
              "# %s %s %s %s #", 13, 10,
              "# %s %s %s %s #", 13, 10,
              "# %s %s %s %s #", 13, 10,
              "#                     #", 13, 10,
              "#######################", 13, 10,
              "Press Esc to exit", 13, 10, 0
game_confirm_exit db "Are you sure? Make another move to continue, ",
                     "or press Esc again to exit", 13, 10, 0
game_state dd 16 dup (0)
clear_screen db "cls", 13, 10, 0  ;# clear screen in windows console
game_state_temp dd 16 dup (0)
blocked_right dd 0
blocked_left dd 0
blocked_down dd 0
blocked_up dd 0

.code
;# ##################### PROCEDURES #####################

@cleaning_blocks:
  mov blocked_left, 0
  mov blocked_up, 0
  mov blocked_down, 0
  mov blocked_right, 0
  ret

@game_check:
;# checks, whether game is changed or not
;# eax=1 if changed, eax=0 otherwise
  push ecx  ;# saving state

  mov ecx, 16
  @checking:            ;# for i=16 to 1
  mov eax, [game_state+ecx*4-4]      ;# game_state[i-1] == game_state_temp[i-1]
  cmp [game_state_temp+ecx*4-4], eax
  jnz @changed    ;# if changed => return eax=1
  loop @checking
  mov eax, 0        ;# eax=0

  jmp @check_end

  @changed:
  mov eax, 1

  @check_end:
  pop ecx ;# restoring state
  ret


@game_save:
;# saves current game state in game_state_temp
  push ecx
  push eax    ;# saving state

  mov ecx, 16       ;# for i=16 to 1
  @saving:
  mov eax, [game_state+ecx*4-4]       ;# game_state_temp[i-1] = game_state[i-1]
  mov [game_state_temp+ecx*4-4], eax
  loop @saving

  pop eax     ;# restoring state
  pop ecx
ret


@game_win:
;# prints score
  call @print_game
  push step
  push score
  push offset game_win
  call printf   ;# printf(&game_win, score, step)
  add esp, 12

  call exit
  ret


@win_check:
;# checking, whether we have 2048 tile or not
;# eax=1 if true, eax=0 otherwise
  push ecx

  mov ecx, 16               ;# for i=16 to 1
  @win_checking:
  mov ebx, [game_state+ecx*4-4]
  cmp ebx, 2048             ;# game_state[i-1] == 2048
  jz @win                   ;# return 1 if true
  loop @win_checking
  mov eax, 0
  jmp @win_end
  @win:
  mov eax, 1

  @win_end:
  pop ecx
  ret


@falling:
;# Tiles are falling to the left
;# Input:
;# - [ebp+8] – first cell address
;# - [ebp+12] – second cell address
;# - [ebp+16] – third cell address
;# - [ebp+20] - fourth cell address
  push ebp      ;# stack handling
  mov ebp, esp

  push eax  ;# saving state
  push ebx
  push ecx
  push esi

  mov ecx, 1
  call @single_fall
  mov ecx, 2
  call @single_fall
  mov ecx, 3
  call @single_fall
  mov ecx, 1
  call @single_fall
  mov ecx, 2
  call @single_fall
  mov ecx, 1
  call @single_fall
  jmp @fall_end

  @single_fall:
    mov esi, dword ptr [ebp+4*ecx+4]
    mov eax, [esi]  ;# falling in steps, 1 2, 2 3 , 3 4 , 1 2 , 2 3 , 1 2
    mov esi, dword ptr [ebp+4*ecx+8]
    mov ebx, [esi]
    cmp eax, 0
    jnz @pass
    xor eax, ebx
    xor ebx, eax
    xor eax, ebx
    @pass:
    mov [esi], ebx
    mov esi, dword ptr [ebp+4*ecx+4]
    mov [esi], eax
    ret

  @fall_end:
  pop esi
  pop ecx ;# restoring state
  pop ebx
  pop eax
  pop ebp
  ret


@merge:
;# Merges available tiles from fourth to first
;# Input:
;# - [ebp+8] – first cell
;# - [ebp+12] – second cell
;# - [ebp+16] – third cell
;# - [ebp+20] - fourth cell

  ;# the idea is to merge following tiles
  ;# 1 2, 2 3, 3 4
  ;# falling happens in intermissions between them
  push ebp    ;# stack handling
  mov ebp, esp

  push eax    ;# saving state
  push ebx
  push ecx
  push esi

  ;# initial falling
  push [ebp+8]
  push [ebp+12]
  push [ebp+16]
  push [ebp+20]
  call @falling
  add esp, 16

  ;# starting of the merge:
  mov ecx, 3
  @lp:
  mov esi, [ebp+4*ecx+4]
  mov eax, [esi]      ;# second value
  mov esi, [ebp+4*ecx+8]
  mov ebx, [esi]      ;# first
  test eax, ebx       ;# testing for merging ability
  jz @jp             ;# jump otherwise
  add ebx, eax          ;# adding to first value
  xor eax, eax          ;# and zeroing the other one
  add score, ebx      ; adding tile value to score
  inc free_tiles      ; also changing number of free tiles
  call @cleaning_blocks ; and removing any blocks we had before
  @jp:
  mov [esi], ebx         ;# moving values back
  mov esi, [ebp+4*ecx+4]
  mov [esi], eax

  push [ebp+8]
  push [ebp+12]
  push [ebp+16]
  push [ebp+20]
  call @falling       ;# starting the fall
  add esp, 16
  loop @lp

  pop esi   ;# restoring state
  pop ecx
  pop ebx
  pop eax

  pop ebp

  ret


@shifter:
;# shifts to choosen direction
;# Input:
;# - direction by key in eax
;# Output:
;# - changing state of game_state
  ;# saving state
  push eax
  push ebx
  push ecx
  push edx
  ;# choosing direction
  cmp eax, 75 ;# left
  jz @left

  cmp eax, 77 ;# right
  jz @right

  cmp eax, 80 ;# down
  jz @down

  cmp eax, 72 ;# up
  jz @up

  pop edx
  pop ecx
  pop ebx
  pop eax

  call getch
  call getch
  jmp @shifter  ;# doing it again otherwise

  @right:
  mov ecx, 4
  @right_loop:
  mov esi, offset game_state
  mov eax, ecx
  mov ebx, 16
  mul ebx
  add esi, eax
  sub esi, 4
  push esi
  sub esi, 4
  push esi
  sub esi, 4
  push esi
  sub esi, 4
  push esi
  call @merge
  add esp, 16
  loop @right_loop

  call @game_check
  cmp eax, 1
  jz @end
  cmp free_tiles, 0
  jnz @end
  mov blocked_right, 1
  jmp @end

  @left:
  mov ecx, 4
  @left_loop:
  mov esi, offset game_state
  mov eax, ecx
  mov ebx, 16
  mul ebx
  add esi, eax
  sub esi, 16
  push esi
  add esi, 4
  push esi
  add esi, 4
  push esi
  add esi, 4
  push esi
  call @merge
  add esp, 16
  loop @left_loop

  call @game_check
  cmp eax, 1
  jz @end
  cmp free_tiles, 0
  jnz @end
  mov blocked_left, 1
  jmp @end

  @down:
  mov ecx, 4
  @down_loop:
  lea esi, [game_state+ecx*4+44]
  push esi
  lea esi, [game_state+ecx*4+28]
  push esi
  lea esi, [game_state+ecx*4+12]
  push esi
  lea esi, [game_state+ecx*4-4]
  push esi
  call @merge
  add esp, 16
  loop @down_loop

  call @game_check
  cmp eax, 1
  jz @end
  cmp free_tiles, 0
  jnz @end
  mov blocked_down, 1
  jmp @end

  @up:
  mov ecx, 4
  @up_loop:
  lea esi, [game_state+ecx*4-4]
  push esi
  lea esi, [game_state+ecx*4+12]
  push esi
  lea esi, [game_state+ecx*4+28]
  push esi
  lea esi, [game_state+ecx*4+44]
  push esi
  call @merge
  add esp, 16
  loop @up_loop

  call @game_check
  cmp eax, 1
  jz @end
  cmp free_tiles, 0
  jnz @end
  inc blocked_up

  @end:
  pop edx ;# restoring state
  pop ecx
  pop ebx
  pop eax
  ret


@print_game:
;# Prints current game state
  push esi  ;# saving state

  invoke system, addr clear_screen ;# clearing screen

  push free_tiles
  push step           ;# printing score
  push score
  push offset game_stats
  call printf
  add esp, 16
              ;# printing current game state
  mov ecx, 16     ;# for i = 16 to 1
  @looping:
  lea esi, [game_state+4*ecx-4]
  mov eax, [esi]
  cmp eax, 0            ;# if game_state[i-1] == 0
  lea esi, tile_list
  jz @dot                ;# push string with dot
  push ecx
  push eax
  push offset int_to_str
  push 8
  push [esi+ecx*4-4]
  call crt__snprintf
  add esp, 16
  pop ecx
  push [esi+ecx*4-4]   ;# otherwise push a converted to string number from tile
  jmp @next
  @dot:
  push offset dot
  @next:
  loop @looping
  push offset game_field
  call printf
  add esp, 68

  pop esi ;# restoring state
  ret


@add_tile:
;# Adds new tile in game_state
  push esi ;# saving state
  push edx
  push ebx
  push eax
  push ecx

  ;# testing whether field is full or not
  cmp free_tiles, 0
  jz @add_end

  ;# choosing random value for tile value, 90% for 2 and 10% for 4
  mov eax, 10
  call @true_random

  cmp eax, 8
  jz @4_tile
  mov ecx, 2
  jmp @again
  @4_tile:
  mov ecx, 4

  @again: ;
  mov eax, 15
  call @true_random ;# choosing random position
  mov esi, offset game_state
  xor edx, edx
  mov ebx, 4
  mul ebx
  add esi, eax          ;# game adress + eax * 4(dd)
  mov eax, [esi]        ;# putting previous value in eax
  cmp eax, 0            ;# if not zero, then choosing another one
  ja @again
  mov eax, ecx
  mov [esi], eax

  @add_end:
  pop ecx
  pop eax ;# restoring state
  pop ebx
  pop edx
  pop esi

  dec free_tiles
  ret

@true_random:
; Recieves number in eax.
; Gives random value from 0 to number in eax. This number included.
; Affects eax, ecx, ebx, edx

  push ebx  ;# saving current state
  push ecx
  push edx

  mov ebx, eax
  call crt_rand;# asking for random value, puts it in eax

  and eax, ebx ;# some magic here

  pop edx ;# restoring state
  pop ecx
  pop ebx

  ret 

@random_seeder:
;# Seeds random numbers from time.
  push eax

  call GetTickCount ;# asking for time passed from system launch
  push eax
  call crt_srand
  add esp, 4
  pop eax

  ret

@game_exit:
;# Confirming exit
  push offset game_confirm_exit
  call printf
  add esp, 4

  call getch
  cmp eax, 27
  jnz @back_to_game ;# if pressed key wasn't Esc - back to game
  call @game_over
  call exit


@game_over:
;# halts the game
  push step           ;# printing score
  push score
  push offset game_over
  call printf
  add esp, 12

  call exit
  ret


@game_test:
; tests if all directions are blocked
  mov eax, 1
  and eax, blocked_right
  and eax, blocked_up
  and eax, blocked_left
  and eax, blocked_down
  ret

@game:
;# Continues playing game:
;# - reads key from keyboard
;# - changes game_field according to shift direction
;# - adds new tile to field
;# - adds one step to step counter

  ;# reading a key from the keyboard
  call getch
  cmp eax, 27     ;# if this key is Esc
  jz @game_exit   ;# ask the user whether he\she sure about exit or not
  @back_to_game:
  call getch  ;# otherwise - ask again(to determine which arrow key was pressed)

  ;# changing game_state
  call @shifter

  ;# checking for winning
  call @win_check
  cmp eax, 1
  jz @game_win

  ; checking for loosing
  call @game_test
  cmp eax, 1
  jz @game_over

  ; checking for changes
  call @game_check
  cmp eax, 0
  jz @not_changed

  ; checking for free space
  cmp free_tiles, 0
  jz @not_changed
  ;# adding new tile
  call @add_tile

  ;# adding one step
  inc step

  @not_changed:
  ;# printing the game to screen
  call @print_game

  ;# saving current game state
  call @game_save

  ret

;# ###################### main ####################
main:
  ;# Seeding a random number generator.
  call @random_seeder

  ;# Starting the game by adding two starting tiles.
  call @add_tile
  call @add_tile
  call @print_game

  ;# saving current game state
  call @game_save

  ;# The game itself.
  @forever:
  call @game
  jmp @forever

end main
