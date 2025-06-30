; hello_console.asm
; Prints "Hello, world!" to the console using Windows API WriteFile

extern GetStdHandle
extern WriteFile
extern ExitProcess

global main

section .data
    msg db "Hello, world!", 13, 10    ; string with CR+LF
    len equ $ - msg                   ; length of the string

section .text
main:
    ; GetStdHandle(STD_OUTPUT_HANDLE = -11)
    mov ecx, -11
    call GetStdHandle                 ; returns HANDLE in rax

    ; WriteFile(handle, buffer, length, &written, NULL)
    mov rcx, rax                     ; HANDLE hFile
    lea rdx, [rel msg]               ; LPCVOID lpBuffer
    mov r8d, len                     ; DWORD nNumberOfBytesToWrite

    sub rsp, 40                     ; shadow space + align stack to 16 bytes
    lea r9, [rsp+32]                ; LPVOID lpNumberOfBytesWritten (write here)
    mov qword [rsp+32], 0           ; initialize written bytes to 0
    mov qword [rsp+40], 0           ; lpOverlapped = NULL

    call WriteFile

    add rsp, 40                    ; restore stack

    ; ExitProcess(0)
    xor ecx, ecx
    call ExitProcess
