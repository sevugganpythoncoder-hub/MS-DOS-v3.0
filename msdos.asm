bits 16
org 0x7C00
start:
    mov ax, 0x0003
    int 0x10
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov si, msg_license
    call print_string
    mov si, msg_drives
    call print_string
.prompt:
    mov si, msg_prompt
    call print_string
    mov di, buffer
    mov cx, 0
.input:
    mov ah, 0x00
    int 0x16
    cmp al, 0x0D
    je .process
    mov ah, 0x0E
    int 0x10
    stosb
    inc cx
    jmp .input
.process:
    mov byte [di], 0
    mov si, newline
    call print_string
    mov si, buffer
    mov di, cmd_help
    call strcmp
    je .do_help
    mov si, buffer
    mov di, cmd_ver
    call strcmp
    je .do_ver
    mov si, msg_bad
    call print_string
    jmp .prompt
.do_help:
    mov si, msg_help
    call print_string
    jmp .prompt
.do_ver:
    mov si, msg_license
    call print_string
    jmp .prompt
print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done: ret
strcmp:
    push si
    push di
.loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .no
    cmp al, 0
    je .yes
    inc si
    inc di
    jmp .loop
.yes: pop di
    pop si
    ret
.no: pop di
    pop si
    stc
    ret
msg_license  db "ASM-OS v1.00 | (C) 2026 ASM CORP | USER LICENSE", 0x0D, 0x0A, 0
msg_drives   db "[C:] RAM:640KB  [X:] RECOVERY:ACTIVE  [G:] VM:CAPABLE", 0x0D, 0x0A, 0x0D, 0x0A, 0
msg_prompt   db "C:\>", 0
cmd_help     db "help", 0
cmd_ver      db "ver", 0
msg_help     db "Commands: ver, help", 0x0D, 0x0A, 0
msg_bad      db "Bad command", 0x0D, 0x0A, 0
newline      db 0x0D, 0x0A, 0
buffer       times 16 db 0
times 510-($-$$) db 0
dw 0xAA55
