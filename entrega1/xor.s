.data
newline: .asciiz "\n"      # Caractere de nova linha
buffer: .space 32          # Buffer para armazenar a linha de entrada
results: .space 200        # Espaço para armazenar os resultados (máximo 50 operações)

.text
.globl main

main:
    # Leitura do número de operações (N)
    li $v0, 5            # Syscall para ler inteiro
    syscall
    move $t0, $v0        # Guardar o número de operações (N) em $t0

    # Inicializar o contador de operações
    li $t1, 0            # Contador de operações (i = 0)
    la $t8, results      # Ponteiro para armazenar os resultados no array

read_operations:
    bge $t1, $t0, print_results # Se já leu todas as operações, ir para a impressão

    # Ler a linha contendo X e Y
    li $v0, 8            # Syscall para ler string
    la $a0, buffer       # Endereço do buffer
    li $a1, 32           # Tamanho máximo da string
    syscall

    # Converter o primeiro número (X)
    la $t2, buffer       # Endereço do buffer
    lb $t3, 0($t2)       # Carregar primeiro caractere
    sub $t3, $t3, 48     # Converter para número (ASCII '0' para '9')
    
    # Pular espaços
    li $t4, 32           # Código ASCII do espaço
loop_skip_space:
    addi $t2, $t2, 1
    lb $t5, 0($t2)       # Carregar o caractere atual apontado por $t2
    bne $t5, $t4, skip_space_found  # Se não for espaço, sair do loop
    j loop_skip_space    # Repetir a verificação

skip_space_found:
    # Converter o segundo número (Y)
    lb $t6, 0($t2)       # Carregar o caractere de Y
    sub $t6, $t6, 48     # Converter de ASCII para número

    xor $t7, $t3, $t6    # t7 = X XOR Y
	beqz $t7, false_case # Se XOR for 0, vá para o caso falso (X == Y)
	li $t7, 2            # Caso verdadeiro (X ≠ Y)
	j store_result
	false_case:
	li $t7, 1            # Caso falso (X == Y)
	store_result:


    # Armazenar o resultado no array (armazenando 1 byte)
    sb $t7, 0($t8)       # Salvar resultado como byte
    addi $t8, $t8, 1     # Avançar ponteiro

    # Incrementar o contador de operações
    addi $t1, $t1, 1
    j read_operations    # Repetir o loop

print_results:
    # Inicializar ponteiro para leitura dos resultados
    la $t8, results      # Apontar para o início do array
    li $t1, 0            # Resetar contador

print_loop:
    bge $t1, $t0, end    # Se todos os resultados foram impressos, terminar

    # Carregar o resultado e imprimir como inteiro
    lb $t7, 0($t8)       # Carregar o resultado (1 byte)
    move $a0, $t7        # Passar valor para registro de argumento
    li $v0, 1            # Syscall para imprimir inteiro
    syscall

    # Imprimir nova linha
    li $v0, 4            # Syscall para string
    la $a0, newline      # Carregar string de nova linha
    syscall

    # Avançar ponteiro e contador
    addi $t8, $t8, 1     # Avançar para próximo resultado (1 byte)
    addi $t1, $t1, 1     # Incrementar contador
    j print_loop         # Voltar ao loop

end:
    # Encerrar programa
    li $v0, 10           # Syscall para sair
    syscall
