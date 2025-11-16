%include 'in_out.asm' ; подключение внешнего файла
SECTION .data

msg: DB 'Введите значение x: ',0
div: DB 'Результат: ',0

SECTION .bss
x: RESB 80

SECTION .text
GLOBAL _start

_start:
; ---- Вычисление выражения
mov eax, msg
call sprint ;Выводим сообщение о вводе X

mov ecx, x ;Вводим X
mov edx, 80
call sread

mov eax, x
call atoi ;ASCII кода в число, `eax=x`

; Вычисление выражения (2+х)^2
mov ebx, eax    ; EBX = x (сохраняем исходное значение)
add eax, 2      ; EAX = x + 2
mov ecx, eax    ; ECX = x + 2 (сохраняем значение для умножения)
mul ecx         ; EAX = EAX * ECX = (x+2) * (x+2) = (2+х)^2

mov edi, eax    ; Записываем конечный результат выражения в edi

; ---- Вывод результата на экран
mov eax, div
call sprintLF   ; Выводим "Результат: " с переводом строки

; ВЫВОД РЕЗУЛЬТАТА
mov eax, edi    ; Помещаем результат обратно в eax
call iprintLF   ; Выводим число из eax с переводом строки

call quit       ; вызов подпрограммы завершения
