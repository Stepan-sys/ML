section .data
    prompt1 db "First number: ", 0
    prompt2 db "Second number: ", 0
    result_msg db "Sum = ", 0
    nl db 0xA
    
section .bss
    buf1 resb 10
    buf2 resb 10
    outbuf resb 10
    n1 resd 1
    n2 resd 1
    
section .text
    global _start

_start:
    ; Запрос первого числа
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt1
    mov rdx, 14
    syscall
    
    ; Чтение первого числа
    mov rax, 0
    mov rdi, 0
    mov rsi, buf1
    mov rdx, 10
    syscall
    
    ; Запрос второго числа
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt2
    mov rdx, 15
    syscall
    
    ; Чтение второго числа
    mov rax, 0
    mov rdi, 0
    mov rsi, buf2
    mov rdx, 10
    syscall
    
    ; Преобразование строк в числа
    call str_to_int
    mov [n1], eax
    
    mov rsi, buf2
    call str_to_int
    mov [n2], eax
    
    ; Сложение
    mov eax, [n1]
    add eax, [n2]
    
    ; Преобразование обратно в строку
    mov edi, outbuf
    call int_to_str
    
    ; Вывод результата
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, 6
    syscall
    
    mov rax, 1
    mov rdi, 1
    mov rsi, outbuf
    mov rdx, 10
    syscall
    
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall
    
    ; Завершение
    mov rax, 60
    xor rdi, rdi
    syscall

; Функция преобразования строки в число
; Вход: RSI = адрес строки
; Выход: EAX = число
str_to_int:
    xor eax, eax
    xor ecx, ecx
.next_char:
    mov cl, [rsi]
    cmp cl, 0xA
    je .done
    cmp cl, '0'
    jb .done
    cmp cl, '9'
    ja .done
    sub cl, '0'
    imul eax, 10
    add eax, ecx
    inc rsi
    jmp .next_char
.done:
    ret

; Функция преобразования числа в строку
; Вход: EAX = число, EDI = буфер
; Выход: строка в буфере
int_to_str:
    mov ebx, 10
    mov ecx, edi
    add ecx, 9
    mov byte [ecx], 0xA
    dec ecx
    
.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    dec ecx
    test eax, eax
    jnz .convert
    
    ; Копируем результат в начало буфера
    inc ecx
    mov esi, ecx
    mov edi, outbuf
    sub ecx, edi
    mov edx, 10
    sub edx, ecx
    rep movsb
    ret