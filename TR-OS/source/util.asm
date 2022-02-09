STRCMP:
STRCMP_LOOP:
LODSB
MOV     BL,[DI]
ADD     DI,1

CMP     BL,0
JZ      STRCMP_DONE_SUCCESS

CMP     AL,BL
JNE     STRCMP_DONE_FAIL



JMP     STRCMP_LOOP
STRCMP_DONE_SUCCESS:
XOR     CX,CX
RET
STRCMP_DONE_FAIL:
MOV     CX,1
RET
ATOI:
xor ax, ax ; zero a "result so far"
.top:
movzx cx, byte [si] ; get a character
inc si ; ready for next one
cmp cx, '0' ; valid?
jb .done
cmp cx, '9'
ja .done
sub cx, '0' ; "convert" character to number
imul ax, 10 ; multiply "result so far" by ten
add ax, cx ; add in current digit
jmp .top ; until done
.done:
ret
SET_STRBUF:
SET_STRBUF_LOOP:
LODSB
MOV [BX], AL
ADD BX, WORD 1
CMP AL,0
JE  SET_STRBUF_DONE
JMP SET_STRBUF_LOOP
SET_STRBUF_DONE:
RET

INT_TO_STRING:
	pusha

	mov cx, 0
	mov bx, 10			; Set BX 10, for division and mod
	mov di, .t			; Get our pointer ready

.push:
	mov dx, 0
	div bx				; Remainder in DX, quotient in AX
	inc cx				; Increase pop loop counter
	push dx				; Push remainder, so as to reverse order when popping
	test ax, ax			; Is quotient zero?
	jnz .push			; If not, loop again
.pop:
	pop dx				; Pop off values in reverse order, and add 48 to make them digits
	add dl, '0'			; And save them in the string, increasing the pointer each time
	mov [di], dl
	inc di
	dec cx
	jnz .pop

	mov byte [di], 0		; Zero-terminate string

	popa
	mov ax, .t			; Return location of string
	ret

        .t times 7 db 0
STRING_COPY:
	pusha

.more:
	mov al, [si]			; Transfer contents (at least one byte terminator)
	mov [di], al
	inc si
	inc di
	cmp byte al, 0			; If source string is empty, quit out
	jne .more

.done:
	popa
	ret
