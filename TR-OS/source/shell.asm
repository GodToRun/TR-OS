%INCLUDE    'CONSTANT.ASM'
SHELL_MAIN: ; main func
XOR         DI,DI
MOV         SI,BOOTMSG
CALL        PRINT ; print boot message
CALL        VER
CALL        PRINT_INPUT ; print input prefix

SHELL_LOOP:
CALL        GET_COMMAND
CALL        INIT_CMD
JMP         SHELL_LOOP

GET_COMMAND:
CALL        GET_INPUT
CALL        COMMAND
CALL        INIT_CMD
CALL        PRINT_INPUT ; print input prefix
RET


GET_INPUT: ; loop
XOR         AH,AH
INT         16H ; bios interrupt 0x16 (read key)

MOV         [CMD+DI],AL
INC         DI

MOV         AH,0X0E
CMP         AL,13
JE          KEY_ENTER ; jump key_enter when press enter
INT         10H ; print key when do not press enter
JMP         GET_INPUT ;infinity loop

KEY_ENTER: ; when press enter
MOV         AL,13
INT         10H ; enter
MOV         AL,10
INT         10H ; CR
RET ; return

COMMAND:
MOV         SI,CMD ; VER CMD
MOV         DI,VER_CMD
CALL        STRCMP
CMP         CX,0
JE          VER

MOV         SI,CMD ; EXIT CMD
MOV         DI,EXIT_CMD
CALL        STRCMP
CMP         CX,0
JE          SHELL_SHUTDOWN

MOV         SI,CMD ; PRINT CMD
MOV         DI,PRINT_CMD
CALL        STRCMP
CMP         CX,0
JE          SHELL_PRINT

MOV         SI,CMD ; CALL CMD
MOV         DI,CALL_CMD
CALL        STRCMP
CMP         CX,0
JE          SHELL_CALL

MOV         SI,CMD ; SAVE CMD
MOV         DI,SAVE_CMD
CALL        STRCMP
CMP         CX,0
JE          SHELL_SAVE

MOV         SI,CMD ; AND CMD
MOV         DI,AND_CMD
CALL        STRCMP
CMP         CX,0
JE          SHELL_AND

MOV         SI,CMD ; OR CMD
MOV         DI,OR_CMD
CALL        STRCMP
CMP         CX,0
JE          SHELL_OR

JMP         UNKNOWN

END_PROGRAM:
CALL        PRINT_NEWLINE
RET

SHELL_AND:
    MOV     CX, AND_STR
    CALL    OPERATION
    RET

SHELL_OR:
    MOV     CX, OR_STR
    CALL    OPERATION
    RET

OPERATION:
CALL    INIT_CMD
CALL    GET_INPUT
MOV     SI,CMD
MOV     DI,.STR_BUF
CALL    STRING_COPY

CALL    INIT_CMD
CALL    GET_INPUT
MOV     SI,CMD

MOV     DI,.STR_BUF
CALL    CX
CALL    INT_TO_STRING
MOV     SI,AX
CALL    PRINT

CALL    INIT_CMD
CALL    PRINT_NEWLINE
RET

.STR_BUF    TIMES   7   DB  0

SHELL_PRINT:
CALL        INIT_CMD
CALL        GET_INPUT
MOV         SI,CMD
CALL        PRINT
CALL        INIT_CMD
CALL        PRINT_NEWLINE
RET

SHELL_SAVE:

CALL        INIT_CMD
CALL        GET_INPUT
MOV         SI,CMD
CALL        ATOI
MOV         BX,AX
CALL        INIT_CMD
CALL        GET_INPUT
MOV         SI,CMD
CALL        ATOI
MOV         [1003],word 80
RET

SHELL_CALL:
CALL        INIT_CMD
CALL        GET_INPUT
MOV         SI,CMD
CALL        ATOI
CALL        AX
CALL        END_PROGRAM
RET

PRINT_NEWLINE:
MOV         SI,NLSTR
CALL        PRINT
NLSTR       DB  13,10,0
RET

VER:
MOV         SI,VERMSG
CALL        PRINT
RET

SHELL_SHUTDOWN:
CALL        SHUTDOWN
CMP         CX,1
JE          SHUTDOWN_FAIL
RET
SHUTDOWN_FAIL:
MOV         SI,SHUTFAILMSG
CALL        PRINT
RET

UNKNOWN:
MOV         SI,UNKNOWN_MSG
CALL        PRINT
RET

PRINT_INPUT: ; print input prefix
MOV         SI,INPUT
CALL        PRINT
RET

INIT_CMD: ; clear command buffer
XOR         DI,DI
XOR         AL,AL

INIT_CMD_REPEAT:
MOV         [CMD+DI],AL
INC         DI
CMP         DI,80
JA          INIT_CMD_DONE
JMP         INIT_CMD_REPEAT

INIT_CMD_DONE:
XOR         DI,DI
RET

; string defination

BOOTMSG     DB  'TR-OS Copyright (C) 2022-2022 All Rights Reserved.',13,10,0
UNKNOWN_MSG DB  'Unknown command',13,10,0
SHUTFAILMSG DB  'Failed to shutdown computer',13,10,0
INPUT       DB  '>',0
CMD         TIMES   256 DB  0
VERMSG      DB  'TR-OS Version [',OSVER,']',13,10,0
VER_CMD     DB  'ver',0
PRINT_CMD   DB  'print',0
EXIT_CMD    DB  'exit',0
CALL_CMD    DB  'call',0
SAVE_CMD    DB  'save',0
AND_CMD     DB  'and',0
OR_CMD     DB  'or',0

; include librarys

%INCLUDE    'SHUTDOWN.ASM'
%INCLUDE    'IO.ASM'
%INCLUDE    'UTIL.ASM'
%INCLUDE    'ALU.ASM'