    .MODEL  SMALL
    .DATA      
    BIT     EQU 20              ; �𰸵����λ��
    ANS     DB  64 DUP(0)       ; ��Ÿ߾��ȴ�
    N       DB  19              ; N Ϊ������׳˵Ķ���
    TEN     DB  10              ; ���10���ƵĻ���

    .CODE
    .STARTUP
    mov     dl, 0
INPUT:
    mov     ah, 1
    int     21h
    sub     al, 30h
    js      FINISH_INPUT
    push    ax
    mov     al, dl
    mov     dl, 10
    mul     dl
    mov     dl, al
    pop     ax
    add     dl, al
    jmp     INPUT

FINISH_INPUT:
    mov     N, dl
    mov     dl, 10
    mov     ah, 2
    int     21h
    mov     dl, 13
    mov     ah, 2
    int     21h
    MOV     CL, N               ; CL ��ŵ�ǰ����
    MOV     ANS, 1              ; ��ʼ���𰸵ĸ�λΪ 1
FOR:                            ; ���δ����������
    CMP     CX, 2
    JS      PRINT               ; ����Ϊ 1 ʱֹͣ
    JMP     WORK                ; ���򽫸ó����˽�������
RTN:
    DEC     CX                  ; ������ 1
    JMP     FOR                 ; �ظ����ϲ���
    
WORK:          
    MOV     BX, 0               ; BX ���ٴ������ƫ���� 
TIMES:                          ; �������˵��𰸵ĸ���λ��
    CMP     BX, BIT             
    JZ      FINISH_TIMES        ; �ѳ������λ��׼����λ
    MOV     AL, CL              
    MUL     BYTE PTR ANS[BX]    ; �˷����������� AL ��
    MOV     ANS[BX], AL         ; �������������Ķ�Ӧλ
    INC     BX                  ; ����ƫ����
    JMP     TIMES               ; ������ʣ���λִ�г˷�����
FINISH_TIMES:
    MOV     BX, 0               ; BX ���ٴ������ƫ����
CARRY:                          ; �Դ�����ִ�н�λ����
    CMP     BX, BIT
    JZ      RTN                 ; ��������н�λ�����Է���
    MOV     AX, 0
    MOV     AL, ANS[BX]
    DIV     BYTE PTR TEN       ; �� 10 ȡ��������
    MOV     ANS[BX], AH         ; �������·Ž���λ
    ADD     ANS[BX+1], AL       ; ����Ϊ��λ�ۼӵ���һλ
    INC     BX                  ; ����ƫ����
    JMP     CARRY               ; ������ʣ���λִ�н�λ����
PRINT:                          ; ��ӡ�߾��ȴ�
    MOV     BX, BIT             ; BX ���ٴ������ƫ����
    MOV     CL, 0               ; CL Ϊ��ʶλ��Ϊ1ʱ0��Ҫ�����
PRINT_DIGIT:                    ; ��ӡһ����λ
    MOV     DL, ANS[BX]         ; DL Ϊ��ǰ���������λ
    CMP     DL, 0
    JZ      SKIP_SET            ; DL ��Ϊ 0�������ñ�־λ
    MOV     CL, 1               ; ����֮��� 0 ������ǰ�� 0
SKIP_SET:
    CMP     CL, 0               
    JZ      SKIP_PRINT          ; ��δ������ 0 �������������
    ADD     DL, 48
    MOV     AH, 2
    INT     21H                 ; �����ǰ��λ��ֵ
SKIP_PRINT:
    CMP     BX, 0               
    JZ      FINISH              ; �Ѵ�ӡ��������λ���������
    DEC     BX                  ; ����ƫ����
    JMP     PRINT_DIGIT         ; ������ӡʣ����λ

FINISH:
    .EXIT
    END

    
