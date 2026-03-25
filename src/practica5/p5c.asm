%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       
	
_start:
    mov edx, msg	
	call puts

    mov eax, msg + 26

    ;use esto porque se me sobrescribia los ultimos 4 caracteres
    mov dl, '@'
    mov [eax], dl

    
    mov edx, msg
    call puts

	mov	eax, 1	    
	int	0x80   

section	.data
    msg	db  'abcdefghijklmnopqrstuvwxyz0123456789',0xa,0 