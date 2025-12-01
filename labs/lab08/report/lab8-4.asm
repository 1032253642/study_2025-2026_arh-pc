section .text
    global _start

_start:
    ; Получаем количество аргументов
    pop ecx        ; argc
    dec ecx        ; пропускаем имя программы
    jz exit        ; если нет аргументов - выходим
    
    mov ebx, 0     ; обнуляем сумму (здесь будет итоговая сумма)
    
process_args:
    ; Получаем следующий аргумент
    pop esi        ; адрес строки аргумента
    
    ; Преобразуем строку в число
    xor eax, eax   ; обнуляем eax (здесь будет текущее число)
    xor edx, edx   ; обнуляем edx
    
convert_loop:
    mov dl, byte [esi]  ; берем очередной символ
    test dl, dl         ; проверяем на конец строки
    jz calculated
    
    cmp dl, '0'
    jb next_arg
    cmp dl, '9'
    ja next_arg
    
    sub dl, '0'         ; преобразуем символ в цифру
    imul eax, 10        ; умножаем текущее значение на 10
    add eax, edx        ; добавляем новую цифру
    
    inc esi             ; следующий символ
    jmp convert_loop

calculated:
    ; Вычисляем 10x - 5
    imul eax, 10        ; умножаем на 10 (10x)
    sub eax, 5          ; вычитаем 5 (10x - 5)
    
    ; Добавляем к общей сумме
    add ebx, eax
    
next_arg:
    ; Следующий аргумент
    dec ecx
    jnz process_args

    ; Выводим результат
    mov eax, ebx        ; результат в eax
    call print_number
    
exit:
    ; Завершение программы
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; код возврата 0
    int 0x80

; Функция для вывода числа
print_number:
    mov ecx, 10         ; делитель
    mov edi, buffer + 10 ; конец буфера
    mov byte [edi], 0   ; нулевой терминатор
    dec edi
    
    mov esi, eax        ; сохраняем число
    test eax, eax       ; проверяем знак
    jns convert         ; если положительное
    
    neg eax             ; делаем положительным для обработки

convert:
    xor edx, edx
    div ecx             ; делим на 10
    add dl, '0'         ; преобразуем в символ
    mov [edi], dl       ; сохраняем символ
    dec edi             ; двигаемся назад в буфере
    test eax, eax       ; проверяем на 0
    jnz convert         ; продолжаем если не 0
    
    ; Если было отрицательное число, добавляем минус
    test esi, esi
    jns print
    mov byte [edi], '-'
    jmp calc_len

print:
    inc edi             ; корректируем позицию

calc_len:
    ; Выводим строку "Результат: "
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, result_msg
    mov edx, result_len
    int 0x80
    
    ; Выводим само число
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, edi        ; указатель на число
    mov edx, buffer + 11
    sub edx, edi        ; вычисляем длину
    int 0x80
    
    ; Выводим перевод строки
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    ret

section .data
    result_msg db 'Результат: ', 0
    result_len equ $ - result_msg
    newline db 10

section .bss
    buffer resb 12
