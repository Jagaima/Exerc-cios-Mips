.data
.text
    .globl main

main:
    # Inicializa as variáveis
    li $t0, 0              # $t0 = contador (número de entradas)
    li $t1, -2147483648    # $t1 = maior número (inicia com o menor valor possível)
    
    # Leitura do número de entradas
    li $v0, 5              # Código para leitura de inteiro
    syscall                # Faz a leitura do número
    move $t2, $v0          # Salva o número de entradas em $t2 (n)

ler_numeros:
    # Lê um número
    li $v0, 5              # Código para leitura de inteiro
    syscall                # Faz a leitura do número
    move $t3, $v0          # Salva o número lido em $t3

    # Compara o número lido com o maior número
    bgt $t3, $t1, atualiza_maior
    
    # Incrementa o contador
    addi $t0, $t0, 1
    beq $t0, $t2, fim      # Se o contador for igual a n, finaliza a execução
    b ler_numeros          # Continua a leitura de números

atualiza_maior:
    move $t1, $t3          # Atualiza o maior número com o valor de $t3
    addi $t0, $t0, 1       # Incrementa o contador após a atualização do maior número
    beq $t0, $t2, fim      # Verifica se o contador atingiu o número total de entradas
    b ler_numeros          # Se não, continua lendo

fim:
    # Exibe o maior número
    move $a0, $t1          # Passa o maior número para o argumento de syscall
    li $v0, 1              # Código para exibir inteiro
    syscall                # Exibe o número

    # Finaliza o programa
    li $v0, 10             # Código para finalizar o programa
    syscall

