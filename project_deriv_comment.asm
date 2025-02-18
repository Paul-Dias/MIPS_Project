.data
    coef:           .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Array para armazenar coeficientes
    exp:            .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Array para armazenar expoentes
    alfabeto:       .asciiz "abcdefghijklmnopqrstuvwxyz"  # String com o alfabeto
    msg1:           .asciiz "Derivada em relacao a "  # Mensagem inicial
    msg2:           .asciiz ": "  # Mensagem de separação
    exp_char:       .asciiz "^"  # Caractere de expoente
    newline:        .asciiz "\n"  # Nova linha
.text
.globl main
main:
    li $v0, 5  # Ler número de termos
    syscall
    move $s0, $v0  # Armazenar número de termos em $s0
    
    li $t0, 0  # Inicializar índice do array
    li $t1, 0  # Inicializar contador de termos
    
ler_entrada:
    li $v0, 5  # Ler coeficiente
    syscall
    sw $v0, coef($t0)  # Armazenar coeficiente no array
    
    li $v0, 5  # Ler expoente
    syscall
    sw $v0, exp($t0)  # Armazenar expoente no array
    
    addi $t1, $t1, 1  # Incrementar contador de termos
    addi $t0, $t0, 4  # Incrementar índice do array
    blt $t1, $s0, ler_entrada  # Repetir até ler todos os termos
    
    li $t0, 0  # Reinicializar índice do array
    li $t1, 0  # Reinicializar contador de termos
    
processar_derivadas:
    beq $t1, $s0, fim  # Se todos os termos foram processados, ir para fim
    
    li $v0, 4
    la $a0, msg1  # Carregar mensagem inicial
    syscall
    
    la $t2, alfabeto  # Carregar endereço do alfabeto
    add $t2, $t2, $t1  # Calcular posição da letra correspondente
    lb $a0, ($t2)  # Carregar letra
    li $v0, 11
    syscall
    
    li $v0, 4
    la $a0, msg2  # Carregar mensagem de separação
    syscall
    
    lw $t3, coef($t0)  # Carregar coeficiente
    lw $t4, exp($t0)  # Carregar expoente
    
    beqz $t4, zero_case  # Se expoente é zero, ir para zero_case
    
    mul $t5, $t3, $t4  # Calcular novo coeficiente (coef * exp)
    
    move $a0, $t5  # Carregar novo coeficiente
    li $v0, 1
    syscall
    
    subi $t4, $t4, 1  # Decrementar expoente
    
    beqz $t4, prox_linha  # Se novo expoente é zero, ir para prox_linha
    
    lb $a0, ($t2)  # Carregar letra
    li $v0, 11
    syscall
    
    li $v0, 4
    la $a0, exp_char  # Carregar caractere de expoente
    syscall
    
    move $a0, $t4  # Carregar novo expoente
    li $v0, 1
    syscall
    
    j prox_linha  # Ir para prox_linha
    
zero_case:
    li $v0, 1
    li $a0, 0  # Carregar zero
    syscall
    
prox_linha:
    li $v0, 4
    la $a0, newline  # Carregar nova linha
    syscall
    
    addi $t0, $t0, 4  # Incrementar índice do array
    addi $t1, $t1, 1  # Incrementar contador de termos
    j processar_derivadas  # Repetir para o próximo termo
    
fim:
    li $v0, 10  # Encerrar programa
    syscall