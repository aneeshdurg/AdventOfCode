default rel
extern printf, exit

%define O_RDONLY 0
%define PROT_READ 0x1
%define MAP_PRIVATE 0x2

section .rodata
; This is the file name. You are free to change it.
fname: db 'input.txt', 0
strfalse: db 'f', 0
strtrue: db 't', 0
endl: db 0xa, 0
message: db "total visible h = %d", 10, 0
lengthmsg: db "size = %d", 10, 0

section .text
global main

; rdi tree data
; rsi grid length
; rdx y
; rcx x
get_tree_data:
  push r12
  mov r12,rsi
  inc r12

  mov r9,rdx ; y
  imul r9,r12 ; y * n
  add r9,rcx ; y * n + x
  mov al, byte [rdi + r9]

  pop r12
  ret

; rdi tree data
; rsi grid length
; rdx y
; rcx x
tree_visible_vert:
  push r12
  push r13
  push r14
  push r15

  mov r12,rdx  ; y
  mov r13,rcx ; x

  call get_tree_data
  mov r15,rax ; byte to compare

  mov r14,0
.loop_above:
  cmp r14,r12
  je .rett ; nothing greater on above, return true

  mov rdx,r14
  mov rcx,r13
  call get_tree_data

  cmp al,r15b
  jge .check_below ; something greater above, check below

  inc r14
  jmp .loop_above

.check_below:
  mov r14,r12
  inc r14
.loop_below:
  cmp r14,rsi
  je .rett ; nothing greater on below, return true

  mov rdx,r14
  mov rcx,r13
  call get_tree_data

  cmp al,r15b
  jge .retf ; something greater on below, return false

  inc r14
  jmp .loop_below

.retf:
  mov rax,0
  jmp .finish
.rett:
  mov rax,1
  jmp .finish
.finish:
  pop r15
  pop r14
  pop r13
  pop r12

  ret

; rdi tree data
; rsi grid length
; rdx y
; rcx x
tree_visible_hrzt:
  push r12
  push r13
  push r14
  push r15

  mov r12,rdx  ; y
  mov r13,rcx ; x

  call get_tree_data
  mov r15,rax ; byte to compare

  mov r14,0
.loop_left:
  cmp r14,r13
  je .rett ; nothing greater on the left, return true

  mov rdx,r12
  mov rcx,r14
  call get_tree_data

  cmp al,r15b
  jge .check_right ; something greater on left, check right

  inc r14
  jmp .loop_left

.check_right:
  mov r14,r13
  inc r14
.loop_right:
  cmp r14,rsi
  je .rett ; nothing greater on the right, return true

  mov rdx,r12
  mov rcx,r14
  call get_tree_data

  cmp al,r15b
  jge .retf ; something greater on the right, return false

  inc r14
  jmp .loop_right

.retf:
  mov rax,0
  jmp .finish
.rett:
  mov rax,1
  jmp .finish
.finish:
  pop r15
  pop r14
  pop r13
  pop r12

  ret

; rdi tree data
print_string:
  push r12
  push r13
  push r14

  mov r14,0 ; number visible


  mov rsi,0
  call string_length
  mov rdx,rax
  mov rax,1
  mov rsi,rdi
  mov rdi,1

  push rsi
  push rdx
  syscall
  pop rsi
  pop rdi

  mov rsi,10
  call string_length
  mov rsi,rax
  mov r12,0

  mov r12,0
.loopy:
  cmp r12,rsi
  je .end
  mov r13,0
.loopx:
  cmp r13,rsi
  je .endx

  mov rdx,r12
  mov rcx,r13
  push rsi
  push rdi
  call tree_visible_hrzt
  cmp rax,0
  jne .printtrue
  mov rdx,r12
  mov rcx,r13
  call tree_visible_vert
  cmp rax,0
  jne .printtrue
  mov rsi,strfalse
  jmp .doprint
.printtrue:
  mov rsi,strtrue
  inc r14
.doprint:
  mov rax,1
  mov rdi,1
  mov rdx,1
  syscall
  pop rdi
  pop rsi

  inc r13
  jmp .loopx
.endx:
  push rsi
  push rdi

  mov rsi,endl
  mov rax,1
  mov rdi,1
  mov rdx,1
  syscall

  pop rdi
  pop rsi

  inc r12
  jmp .loopy
.end:

  sub   rsp, 8             ; re-align the stack to 16 before calling another function
  ; Call printf.
  mov   esi, r14d    ; "%x" takes a 32-bit unsigned int
  lea   rdi, [rel message]
  xor   eax, eax           ; AL=0  no FP args in XMM regs
  call  printf
  add   rsp, 8

  pop r14
  pop r13
  pop r12

  ret

; rdi - string ptr
; rsi - delimiter for length
string_length:
    xor rax, rax
.loop:
    cmp byte [rdi+rax], sil
    je .end
    inc rax
    jmp .loop
.end:
    ret

main:
; call open
mov rax, 2
mov rdi, fname
mov rsi, O_RDONLY    ; Open file read only
mov rdx, 0 	         ; We are not creating a file
                     ; so this argument has no meaning
syscall

; mmap
mov r8, rax           ; rax holds opened file descriptor
                      ; it is the fourth argument of mmap
mov rax, 9            ; mmap number
mov rdi, 0            ; operating system will choose mapping destination
mov rsi, 16384         ; page size
mov rdx, PROT_READ    ; new memory region will be marked read only
mov r10, MAP_PRIVATE  ; pages will not be shared

mov r9, 0             ; offset inside test.txt
syscall               ; now rax will point to mapped location

mov rdi, rax
call print_string

mov rax, 60           ; use exit system call to shut down correctly
xor rdi, rdi
syscall

