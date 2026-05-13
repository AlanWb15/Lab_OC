%include "../../lib/pc_io.inc"
section	.text
	global _start
	
_start:                     ;espero nunca usar ASM en mi vida 
   _start:

    mov esi, 0

    .capturarLoop:

    mov bx, word[len]
    mov edx, cad
    call capturar
    mov al, 0xa
    call putchar

    mov edx, cad
    call atoi

    mov eax, dword[numero]
    mov dword[arr + esi*4], eax

    inc esi
    cmp esi, 5
    jl .capturarLoop

    mov edx, ncad
    call puts

    call ordenar

    mov esi, 0
    .mostrarLoop:
    mov eax, dword[arr + esi*4]
    mov edx, cad
    mov bl, byte[lencad]
    call itoa
    call puts

    mov al, ' '
    call putchar

    inc esi
    cmp esi, 5
    jl .mostrarLoop


    mov eax, 1
    int 0x80
	
    capturar: 
            push cx
            push edx
            push ebx 
            mov cx, bx
            dec cx
            mov ebx, 0
    .ciclo:
            call getch 
            cmp al, 0xa
            je .salir
            cmp bx, 0
            cmp al, 0x7f
            jne .guardar
            cmp bx, 0
            je .ciclo
            call borrar
            dec bx
            loop .ciclo

    .guardar:
        call putchar
        mov [edx + ebx], al
        inc bx
        loop .ciclo

   .salir:
        mov byte [edx + ebx], 0
        pop ebx
        pop edx
        pop cx
        ret 
    
borrar: 
        push ax
        mov al, 0x8
        call putchar 
        mov al, ' '
        call putchar 
        mov al, 0x8
        call putchar 
        pop ax
        ret


    impArreglo:
        push ecx
        push esi
        mov ecx,0
        mov esi,0
        mov cl,dl   
       .cicloImpArr:
        push eax
        push edx
        mov edx,eax
        mov eax,dword[edx+esi*4]    
        mov edx,cad
        mov bl,byte[lencad]
        call itoa
        mov edx,cad
        call puts
        mov al,' '
        call putchar
        inc esi
        pop edx
        pop eax
        loop .cicloImpArr
        pop esi
        pop ecx
        ret 
    
    atoi:
        push esi
        push eax
        push edx
        push ebx
        mov esi, 0
        mov dword[numero],0
        mov dword[multi],1

        .espacios:                         
        movzx eax, byte[edx + esi]
        cmp eax,' '
        je .saltaEspacio
        cmp eax,0x09        ;TAB
        je .saltaEspacio
        jmp .ciclo

        .saltaEspacio:
        inc esi
        jmp .espacios 

        .ciclo:
        movzx eax, byte[edx + esi]
        cmp eax,0
        je .finCadena
        inc esi
        jmp .ciclo

       

        .finCadena:      
        dec esi

        .convertir:
        movzx eax, byte[edx + esi]
        cmp eax,'0'
        jl .exit
        cmp eax,'9'
        jg .exit
        sub eax,'0'
        push edx           
        mul dword[multi]
        add dword[numero],eax
        mov eax,dword[multi]
        mul dword[base]
        mov dword[multi],eax
        pop edx           
        dec esi
        cmp esi,0
        jl .exit      
        cmp esi,0
        je .signo
        jmp .convertir

        .signo:
        cmp byte[edx+esi],'-'
        jne .convertir
        mov eax,dword[numero]
        neg eax
        mov dword[numero],eax

        .exit:
        pop ebx
        pop edx
        pop eax
        pop esi
        ret

    itoa:
        push dword[divBase]
        pop dword[divi]
        push esi
        mov esi,0
        mov dword[cociente],0
        mov dword[residuo],0
        mov dword[numero],eax        
        cmp eax,0
        jge .while 
        mov byte[edx+esi],'-'
        inc esi
        neg eax
        mov dword[numero],eax
       
        .while:
        push edx
        mov eax,dword[numero]
        mov edx,0
        idiv dword[divi]
        cmp eax,0
        jne .salir
        mov edx,0
        mov eax,dword[divi]
        idiv dword[base]
        mov dword[divi],eax                
        pop edx
        jmp .while
        
        .salir:
        pop edx
        .do:
        push edx
        mov edx,0
        mov eax,dword[numero]
        idiv dword[divi]
        mov dword[cociente],eax
        mov dword[residuo],edx
        pop edx
        add dword[cociente],'0'
        push ebx
        mov bl,byte[cociente]
        mov byte[edx+esi],bl
        pop ebx
        inc esi
        push dword[residuo]
        pop dword[numero]
        push edx
        mov edx,0
        mov eax,dword[divi]
        idiv dword[base]
        mov dword[divi],eax  
        pop edx
        cmp dword[numero],0
        jg .do        
        mov byte[edx+esi],0
        pop esi
        ret

ordenar:

    push esi
    push edi 
    
    push eax
    push edx
    push ecx

    mov esi, 0
    mov edi, 0

   
    mov eax, esi
    shl eax, 2
    add eax, arr
   

    .ordenarLoopA:

        mov edi, esi
        inc edi 

        .ordenarLoopB:

        mov eax, esi
        shl eax, 2
        add eax, arr

        mov ecx, dword[eax]
        cmp ecx, dword[eax + 4]
        jle .noSwap
        


    .Swap:
    
    mov ecx, dword[eax]
    mov edx, dword[eax + 4]
    mov dword[eax], edx
    mov dword[eax + 4], ecx

    .noSwap: 

    inc edi
    mov ecx, 4
    sub ecx, esi
    cmp edi, ecx
    jl .ordenarLoopB

    inc esi
    cmp esi, 4
    jl .ordenarLoopA



    .salida:
    
    pop ecx
    pop edx
    pop eax
    pop edi
    pop esi 
    ret





section	.data
    ncad db 0xa,'Arreglo: ',0
    lencad db 64
    cad times 64 db 0
    len dw 6
    arr times 5 dd 0
    
    numero dd 0
    cociente dd 0
    residuo dd 0
    base dd 10
    multi dd 1
    divBase dd 1000000000
    divi dd 0