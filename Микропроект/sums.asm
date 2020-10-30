format PE CONSOLE                            ; 32-��������� ���������� ��������� WINDOWS EXE
entry start                                  ; ����� �����

include 'include\win32a.inc'

section '.idata' import data readable        ; ������ ������������� �������

library kernel,'kernel32.dll',\
        msvcrt,'msvcrt.dll'

import  kernel,\
        ExitProcess,'ExitProcess'

import  msvcrt,\
	sscanf,'sscanf',\
	gets,'gets',\
	getch,'_getch',\
	printf,'printf'

section '.data' data readable writeable      ; ������ ������
n equ 15
A	dd 15 dup (0)
s	db 128 dup (0)
msg1	db 'Input array:',13,10,0
msg2	db 'Array:',13,10,0
msg3	db 13,10,'Sum of positives = %d',13,10,0
msg4	db 'Sum of negatives = %d',13,10,0
str0	db 'A[%d] = ',0	;����������� ��� ������ ������
fmt	db '%d',0
fmt1	db '%5d',0


section '.code' code readable executable     ; ������ ����
start:                                       ; ����� ����� � ���������
	ccall [printf],msg1	;����� ���������
	ccall input,A,n		;���� �������
	ccall [printf],msg2	;����� ���������
	ccall show,A,n		;����� �������
	ccall sumpos,A,n	;����� ������������� �����
	ccall [printf],msg3,eax	;����� �����
	ccall sumneg,A,n        ;����� ������������� �����
	ccall [printf],msg4,eax	;����� �����
	ccall [getch]		;������� ������� ����� �������
	stdcall [ExitProcess], 0;�����
;void input(int *a,int n)
;���� �������
;���������� ������ cdecl
input:
	push ebp		;������� ���� �����
	mov ebp,esp
	push ebx		;��������� �������� �� ���������� stdcall
	push esi
;���� �������
	mov ebx,[ebp+8]		;������ �������
	mov esi,1		;����� ��������
inpmas:	ccall [printf],str0,esi	;����� ���������
	ccall [gets],s		;���� ������
	ccall [sscanf],s,fmt,ebx;�������������� ������ � �����
	test eax,eax		;���� ������
	jle inpmas		;��������� ����
	add ebx,4		;��������� �������
	inc esi			;����� ���������� ��������
	cmp esi,[ebp+12]	;���������� � �������� �������
	jbe inpmas		;���� ������ ��� ����, ����������
	pop esi			;������������ ��������
	pop ebx
	pop ebp			;������ �������
	ret
;void show(int *a,int n)
;����� �������
;���������� ������ cdecl
show:
	push ebp		;������� ���� �����
	mov ebp,esp
	push ebx		;��������� �������� �� ���������� stdcall
	push esi
;����� �������
	mov esi,[ebp+12]	;���������� ��������� � �������
	mov ebx,[ebp+8]		;������ �������
mo6:    ccall [printf],fmt1,[ebx]	;����� �������� �������
	add ebx,4		;��������� � ���������� �������� �������
	dec esi			;��������� ���������� ���������� ���������
	jnz mo6			;���������� ���� �� 0
	pop esi			;������������ ��������
	pop ebx
	pop ebp			;������ �������
	ret
;int sumpos(int *a,int n)
;����� ������������� ��������� �������
;���������� ������ cdecl
sumpos:
	push ebp		;������� ���� �����
	mov ebp,esp
	push ebx		;��������� �������� �� ���������� stdcall
	mov ecx,[ebp+12]	;���������� ��������� � �������
	mov ebx,[ebp+8]		;������ �������
	mov eax,0		;����� �������������=0
s1:     cmp dword [ebx],0	;���� ����� �� �������������
	jng s2			;����������
	add eax,[ebx]		;��������� � ����� �������������
s2:	add ebx,4		;��������� � ���������� �������� �������
	loop s1			;���� �� �������
	pop ebx                 ;������������ ��������
	pop ebp			;������ �������
	ret
;int sumneg(int *a,int n)
;����� ������������� ��������� �������
;���������� ������ cdecl
sumneg:
	push ebp		;������� ���� �����
	mov ebp,esp
	push ebx		;��������� �������� �� ���������� stdcall
	mov ecx,[ebp+12]	;���������� ��������� � �������
	mov ebx,[ebp+8]		;������ �������
	mov eax,0		;����� �������������=0
s3:     cmp dword [ebx],0	;���� ����� �� �������������
	jnl s4			;����������
	add eax,[ebx]		;��������� � ����� �������������
s4:	add ebx,4		;��������� � ���������� �������� �������
	loop s3			;���� �� �������
	pop ebx                 ;������������ ��������
	pop ebp			;������ �������
	ret
