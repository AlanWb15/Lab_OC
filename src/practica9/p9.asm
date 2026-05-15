section .data
    cur_max  dd 0
    cur_min  dd 0
    cur_sum  dd 0
    arr_ptr  dd 0
    arr_idx  dd 0

section .text
    global maximo
    global minimo
    global sumatoria

%macro FOR 4
    push ecx
    push edx
    mov  ecx, %1
    mov  edx, %2
    .%4:
    call %3
    loop .%4
    pop  edx
    pop  ecx
%endmacro

maximo:
    push ebp
    mov  ebp, esp
    push ebx
    push ecx
    push edx
    mov  esi, [ebp + 8]
    mov  eax, [esi]
    mov  [cur_max], eax
    mov  [arr_ptr],  esi
    mov  dword [arr_idx], 1
    mov  ecx, [ebp + 12]
    dec  ecx
    cmp  ecx, 0
    jle  fin_max
    FOR  ecx, esi, comp_max, loop_max
fin_max:
    mov  eax, [cur_max]
    pop  edx
    pop  ecx
    pop  ebx
    pop  ebp
    ret

comp_max:
    mov  esi, [arr_ptr]
    mov  edi, [arr_idx]
    mov  ebx, [esi + edi*4]
    mov  eax, [cur_max]
    cmp  ebx, eax
    jle  skip_max
    mov  [cur_max], ebx
skip_max:
    inc  dword [arr_idx]
    ret

minimo:
    push ebp
    mov  ebp, esp
    push ebx
    push ecx
    push edx
    mov  esi, [ebp + 8]
    mov  eax, [esi]
    mov  [cur_min], eax
    mov  [arr_ptr],  esi
    mov  dword [arr_idx], 1
    mov  ecx, [ebp + 12]
    dec  ecx
    cmp  ecx, 0
    jle  fin_min
    FOR  ecx, esi, comp_min, loop_min
fin_min:
    mov  eax, [cur_min]
    pop  edx
    pop  ecx
    pop  ebx
    pop  ebp
    ret

comp_min:
    mov  esi, [arr_ptr]
    mov  edi, [arr_idx]
    mov  ebx, [esi + edi*4]
    mov  eax, [cur_min]
    cmp  ebx, eax
    jge  skip_min
    mov  [cur_min], ebx
skip_min:
    inc  dword [arr_idx]
    ret

sumatoria:
    push ebp
    mov  ebp, esp
    push ebx
    push ecx
    push edx
    mov  esi, [ebp + 8]
    mov  dword [cur_sum], 0
    mov  [arr_ptr], esi
    mov  dword [arr_idx], 0
    mov  ecx, [ebp + 12]
    cmp  ecx, 0
    jle  fin_sum
    FOR  ecx, esi, comp_sum, loop_sum
fin_sum:
    mov  eax, [cur_sum]
    pop  edx
    pop  ecx
    pop  ebx
    pop  ebp
    ret

comp_sum:
    mov  esi, [arr_ptr]
    mov  edi, [arr_idx]
    mov  ebx, [esi + edi*4]
    add  [cur_sum], ebx
    inc  dword [arr_idx]
    ret