%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
							    	; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       
	
    _start: 

        
        mov edx, ncad		
        call puts

        mov bx, word[len]
        mov edx, cad 
        call capturar

        mov al, [nlin]
        call putchar

        mov edx, cad
        call puts

        mov al, [nlin]
        call putchar

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
            cmp al, 0x7f
            jne .guardar
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
    

section	.data

    ncad db  0xa, 'Cadena:',0 
    nlin db 0xa
    len db 64
    cad times 64 db 0    ;cadena 

