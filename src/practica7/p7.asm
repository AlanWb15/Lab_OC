%include "../../lib/pc_io.inc"
section	.text
	global _start
	
_start:                     ;espero nunca usar ASM en mi vida 
    mov edx,cadCon
    mov bl,byte[lencad]
    call atoi

    mov al,10
    call putchar
    
    mov eax,40
    mov edx,cad
    mov bl,byte[lencad]
    call itoa
    call puts
    mov edx,ncad
    call puts
    mov eax,arr
    mov edx,0
    mov dl,byte[len]
    call impArreglo
    mov al,10
    call putchar
    
	mov	eax, 1
	int	0x80                ;bye 

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
        mov esi,-1
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
        je .exit
        cmp esi,1
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

section	.data
    ncad db 0xa,'Arreglo: ',0
    cadCon db 0xa,'-88',0
    nlin db 0xa
    lencad db 64
    cad	times 64 db 0
    len db 5
    arr	dd 32,3,67,4,22
    
    numero dd 0
    cociente dd 0
    residuo dd 0
    base dd 10
    multi dd 1
    divBase dd 1000000000
    divi dd 0