%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       
	
_start:
    mov edx, msg	
	call puts

    ; direccionamiento por base + indice con desplazamiento 0
    mov ebx, msg      ; base
    mov ecx, 15       ; indice
    mov byte [ebx + ecx + 0], 'P' ; desplazamiento + indice

    mov edx, msg	
	call puts

	mov	eax, 1	    
	int	0x80   

section	.data
    msg	db  'abcdefghijklmnopqrstuvwxyz0123456789',0xa,0 