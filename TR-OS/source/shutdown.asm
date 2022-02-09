SHUTDOWN:
    mov ax, 0x1000
    mov ax, ss
    mov sp, 0xf000
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15

WAIT_FOR_ENTER:
    MOV ah, 0
    INT 0x16
    CMP al, 0x0D
    JNE FAIL
    RET
FAIL:
    MOV CX,1
    RET