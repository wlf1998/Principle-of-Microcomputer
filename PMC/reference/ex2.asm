
    .MODEL SMALL
    .STACK 100H
    .DATA 
BUFFER  db  0
FILE    db  "2.txt", 0
HANDLE  dw  0
NUM     db  1024  DUP(0)
SCALE   db  0
TEN     db  10
HUNDRED db  100

    .CODE
    .STARTUP
OPEN_FILE:
    mov     ah, 3dh             ; ���ļ�
    mov     al, 0               ; 0-read only
    lea     dx, FILE            ; �ļ����Ƶ�ַ
    int     21h             
    jc      QUIT                ; if err
    mov     HANDLE, ax          ; ����洢
    lea     bx, NUM             ; bx��¼�ֽڴ洢��ַ
    mov     cx, 0               ; cx��¼�Ѵ洢����

START_NEW_NUM:                  ; �µ�����  
    mov     dx, 0               ; ÿ�������Ѷ��ַ�
START_NEW_DIG:                  ; �µ�λ��
    push    bx  
    push    cx
    push    dx

    mov     bx, HANDLE        
    mov     ah, 3fh             ; ��ȡ�ַ�
    lea     dx, BUFFER          ; ������
    mov     cx, 1               ; ֻ��1���ַ�
    int     21h

    pop     dx
    pop     cx
    pop     bx

    test    ax, ax              ; �鿴�Ƿ�EOF-0
    jz      FINISH_READ 

    mov     dh, BUFFER
    sub     dh, 30h
    js      SKIP_ADD_DIG        ; ��������
    mov     al, 10
    mul     dl
    mov     dl, al              ; dl = dl * 10,�����λ
    add     dl, dh 
    jmp     START_NEW_DIG

SKIP_ADD_DIG:
    mov     ah, BUFFER
    sub     ah, 20h
    jnz     FINISH_READ
    inc     cx
    mov     [bx], dl            ; �洢���ֵ�NUM����
    inc     bx
    jmp     START_NEW_NUM

FINISH_READ:

    mov     SCALE, cl    

SORT:                           ; һ�� SCALE-1��
    dec     cl                  
    jz      FINISH_SORT
    mov     bl, 1

BUBBLE_SORT:
    cmp     bl, SCALE
    jz      SORT
    mov     dl, NUM[bx-1]
    mov     dh, 0
    mov     al, NUM[bx]
    mov     ah, 0
    cmp     ax, dx
    jns     SKIP_SWAP
    mov     NUM[bx-1], al
    mov     NUM[bx], dl

SKIP_SWAP:                      ; swap
    inc     bl
    jmp     BUBBLE_SORT

FINISH_SORT:    
    mov     bx, 0

OUTPUT:                         ; OUTPUT
    cmp     bl, SCALE
    jz      QUIT
    jmp     PRINT

RTN:
    inc     bx
    jmp     OUTPUT

PRINT:
    mov     al, NUM[bx]
    mov     ah, 0
    div     HUNDRED             ; ��λ
    mov     dx, ax
    add     dl, 30h
    mov     ah, 2
    int     21h

    mov     ah, 0
    mov     al, dh
    div     TEN                 ; ʮλ
    mov     dx, ax
    add     dl, 30h
    mov     ah, 2
    int     21h

    mov     dl, dh
    add     dl, 30h             ; ��λ
    mov     ah, 2
    int     21h

    mov     dl, 20h             ; �ո�
    mov     ah, 2
    int     21h
    jmp     RTN

QUIT:
    .EXIT
    end