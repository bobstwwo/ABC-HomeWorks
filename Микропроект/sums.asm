format PE CONSOLE                            ; 32-разрядная консольная программа WINDOWS EXE
entry start                                  ; точка входа

include 'include\win32a.inc'

section '.idata' import data readable        ; секция импортируемых функций

library kernel,'kernel32.dll',\
        msvcrt,'msvcrt.dll'

import  kernel,\
        ExitProcess,'ExitProcess'

import  msvcrt,\
	sscanf,'sscanf',\
	gets,'gets',\
	getch,'_getch',\
	printf,'printf'

section '.data' data readable writeable      ; секция данных
n equ 15
A	dd 15 dup (0)
s	db 128 dup (0)
msg1	db 'Input array:',13,10,0
msg2	db 'Array:',13,10,0
msg3	db 13,10,'Sum of positives = %d',13,10,0
msg4	db 'Sum of negatives = %d',13,10,0
str0	db 'A[%d] = ',0	;формируемая для вывода строка
fmt	db '%d',0
fmt1	db '%5d',0


section '.code' code readable executable     ; секция кода
start:                                       ; точка входа в программу
	ccall [printf],msg1	;вывод сообщения
	ccall input,A,n		;ввод массива
	ccall [printf],msg2	;вывод сообщения
	ccall show,A,n		;вывод имссива
	ccall sumpos,A,n	;сумма положительных чисел
	ccall [printf],msg3,eax	;вывод суммы
	ccall sumneg,A,n        ;сумма отрицательных чисел
	ccall [printf],msg4,eax	;вывод суммы
	ccall [getch]		;ожидаем нажатия любой клавиши
	stdcall [ExitProcess], 0;выход
;void input(int *a,int n)
;Ввод массива
;соглашение вызова cdecl
input:
	push ebp		;создать кадр стека
	mov ebp,esp
	push ebx		;Сохранить регистры по соглашению stdcall
	push esi
;Ввод массива
	mov ebx,[ebp+8]		;начало массива
	mov esi,1		;номер элемента
inpmas:	ccall [printf],str0,esi	;вывод сообщения
	ccall [gets],s		;ввод строки
	ccall [sscanf],s,fmt,ebx;преобразование строки в число
	test eax,eax		;если ошибка
	jle inpmas		;повторить ввод
	add ebx,4		;следующий элемент
	inc esi			;номер следующего элемента
	cmp esi,[ebp+12]	;сравниваем с размером массива
	jbe inpmas		;если меньше или рано, продолжить
	pop esi			;восстановить регистры
	pop ebx
	pop ebp			;эпилог функции
	ret
;void show(int *a,int n)
;Вывод массива
;соглашение вызова cdecl
show:
	push ebp		;создать кадр стека
	mov ebp,esp
	push ebx		;Сохранить регистры по соглашению stdcall
	push esi
;вывод массива
	mov esi,[ebp+12]	;количество элементов в массиве
	mov ebx,[ebp+8]		;начало массива
mo6:    ccall [printf],fmt1,[ebx]	;вывод элемента массива
	add ebx,4		;переходим к следующему элементу массива
	dec esi			;уменьшаем количество оставшихся элементов
	jnz mo6			;продолжить пока не 0
	pop esi			;восстановить регистры
	pop ebx
	pop ebp			;эпилог функции
	ret
;int sumpos(int *a,int n)
;Сумма положительных элементов массива
;соглашение вызова cdecl
sumpos:
	push ebp		;создать кадр стека
	mov ebp,esp
	push ebx		;Сохранить регистры по соглашению stdcall
	mov ecx,[ebp+12]	;количество элементов в массиве
	mov ebx,[ebp+8]		;начало массива
	mov eax,0		;сумма положительных=0
s1:     cmp dword [ebx],0	;если число не положительное
	jng s2			;пропустить
	add eax,[ebx]		;прибавить к сумме положительных
s2:	add ebx,4		;переходим к следующему элементу массива
	loop s1			;цикл по массиву
	pop ebx                 ;восстановить регистры
	pop ebp			;эпилог функции
	ret
;int sumneg(int *a,int n)
;Сумма отрицательных элементов массива
;соглашение вызова cdecl
sumneg:
	push ebp		;создать кадр стека
	mov ebp,esp
	push ebx		;Сохранить регистры по соглашению stdcall
	mov ecx,[ebp+12]	;количество элементов в массиве
	mov ebx,[ebp+8]		;начало массива
	mov eax,0		;сумма отрицательных=0
s3:     cmp dword [ebx],0	;если число не отрицательное
	jnl s4			;пропустить
	add eax,[ebx]		;прибавить к сумме отрицательных
s4:	add ebx,4		;переходим к следующему элементу массива
	loop s3			;цикл по массиву
	pop ebx                 ;восстановить регистры
	pop ebp			;эпилог функции
	ret
