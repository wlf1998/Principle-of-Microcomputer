
        .MODEL SMALL
        .DATA
ARRAY   DB  36 DUP(0)       ; ����Ԫ�ش洢����
TEN     DB  10              ; ʮ���ƵĻ���
SIX     DB  6               ; ��ά����Ļ���
        
        .CODE
        .STARTUP
        LEA     BX, ARRAY   
        MOV     CX, 36
        MOV     DL, 1

FILL:   MOV     [BX], DL    ; ����Ҫ���������
        INC     BX
        INC     DL
        DEC     CX
        JNZ     FILL
        
        LEA     BX, ARRAY   ; ����ָ��
        MOV     CH, 0       ; ��¼�к�
        MOV     CL, 0       ; ��¼�к�
        
LOOP:   MOV     AL, CH      ; �ж��Ƿ���Ҫ��ӡ����
        SUB     AL, CL
        JGE     PRINT_NUM   ; �кŴ��ڵ����кţ���ӡ����

RTN1:   MOV     AL, CL      ; �ж��Ƿ���Ҫ��ӡ�س� 
        SUB     AL, 5
        JZ      PRINT_CRLF  ; �кŵ���5����ӡ�س�
        
RTN2:   MOV     AL, CL      ; ��������
        MOV     AH, 0
        INC     AL
        DIV     SIX
        MOV     CL, AH      ; AH ������CL-��
        ADD     CH, AL      ; AL �̣�CH-��
        INC     BX

        MOV     AL, CH      ; �жϳ����Ƿ�Ӧ�ý���
        SUB     AL, 6       
        JZ      OVER        ; �к�Ϊ6ʱ����������

        JMP     LOOP


PRINT_NUM: 
        MOV     AL, [BX]    ; AX ��Ϊ����ӡ������     
        MOV     AH, 0
        DIV     TEN         ; AL �̣�AH 
                            ; ����������10֮�����ʮλ���͸�λ��
        ADD     AL, 48      ; 48 '0'
        ADD     AH, 48
        MOV     DX, AX
        MOV     AH, 2
        INT     21H         ; ��ӡʮλ
        MOV     DL, DH
        INT     21H         ; ��ӡ��λ
        MOV     DL, 32
        INT     21H         ; ��ӡ�ո�              
        JMP     RTN1

PRINT_CRLF: 
        MOV     AH, 2       ; ��ӡ�س�
        MOV     DL, 13
        INT     21H
        MOV     DL, 10
        INT     21H
        JMP     RTN2 

OVER:        
        .EXIT        
        END
