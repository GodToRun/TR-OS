AND_STR: ; SI, DI, OUTPUT: AX
CALL    OPERATE_STR
AND     AX,BX
RET

OR_STR: ; SI, DI, OUTPUT: AX
CALL    OPERATE_STR
OR     AX,BX
RET

OPERATE_STR: ; SI, DI, OUTPUT: AX
CALL    ATOI
MOV     BX, AX

MOV     SI,DI
CALL    ATOI
RET