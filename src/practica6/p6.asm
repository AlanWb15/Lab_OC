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

        mov edx, cad   
        call mayusculas

        mov al, [nlin]
        call putchar

        mov edx, cad
        call puts

        mov al, [nlin]
        call putchar

        mov edx, cad   
        call minusculas

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

mayusculas:
                push cx
                push edx
                push ebx 
                mov cx, bx
                dec cx
                mov ebx, 0
                
        .ciclo:
                mov al, [edx]
                cmp al, 0 
                je .salir

        

                cmp al, 'a'
                jb .sig
        
                cmp al, 'z'
                ja .sig

                sub al, 32
                mov [edx], al

                inc edx
                loop .ciclo

        .sig:
                
                inc edx
                loop .ciclo
        .salir:
                mov byte [edx + ebx], 0
                pop ebx
                pop edx
                pop cx
                ret 

minusculas:
                push cx
                push edx
                push ebx 
                mov cx, bx
                dec cx
                mov ebx, 0
                
        .cicloB:
                mov al, [edx]
                cmp al, 0 
                je .salirB

        

                cmp al, 'A'
                jb .sigB
        
                cmp al, 'Z'
                ja .sigB

                add al, 32
                mov [edx], al

                inc edx
                loop .cicloB

        .sigB:
                
                inc edx
                loop .cicloB
        .salirB:
                mov byte [edx + ebx], 0
                pop ebx
                pop edx
                pop cx
                ret 
                


    

section	.data

    ncad db  0xa, 'Cadena:',0 
    nlin db 0xa
    len db 64
    cad times 64 db 0    ;cadena 

