 format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

        string_array_size   db 'Input the size of array: ', 0
        string_array_element  db 'Input [%d] element of array: ', 0
        string_output db 'Index of %d is %d. ',10,0
        string_input   db '%d', 0
        string_incorrect db 'Incorrect value of array = %d', 10, 0
        NULL = 0

        array_size   dd 0
        count        dd ?
        total_amount dd 0
        tmp          dd ?
        tmpStack     dd ?
        vec          rd 100

section '.code' code readable executable
start:
; 1) vector input
        call VectorInput
; 2) output of vector B
        call VectorOut
finish:
        call [getch]

        push NULL
        call [ExitProcess]

VectorInput:
        push string_array_size
        call [printf]
        add esp, 4

        push array_size
        push string_input
        call [scanf]
        add esp, 8

        mov eax, [array_size]
        cmp eax, 0
        jg  getVector

        push array_size
        push string_incorrect
        call [printf]
        push NULL
        call [ExitProcess]

getVector:
        xor ecx, ecx
        mov ebx, vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [array_size]
        jge endInputVector


        mov [count], ecx
        push ecx
        push string_array_element
        call [printf]
        add esp, 8

        push ebx
        push string_input
        call [scanf]
        add esp, 8

        mov ecx, [count]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret

VectorSum:
        xor ecx, ecx
        mov ebx, vec
sumVecLoop:

        cmp ecx, [array_size]
        je endSumVector
        mov eax, [total_amount]
        add eax, [ebx]
        mov [total_amount], eax


        inc ecx

        add ebx, 4
        jmp sumVecLoop
endSumVector:
        ret

VectorOut:
        mov [tmpStack], esp
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
putVecLoop:

        cmp ecx, [array_size]
        je endOutputVector

        mov eax,[ebx]
        cmp eax,0
        jg showData
        inc ecx
        add ebx,4
        jmp putVecLoop


endOutputVector:
        mov esp, [tmpStack]
        ret

showData:
       ; mov eax,ecx
        mov [ebx], eax
        mov [count], ecx
        mov [tmp], ebx

        push ecx
        push dword [ebx]

        push string_output
        call [printf]

        mov ecx, [count]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop

                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'