.data
    input: .skip 20           #buffer 
    output: .skip 20          #buffer 

.text   

.globl _start
    read:
        li a0, 0             # file descriptor = 0 (stdin)
        la a1, input         # buffer to write the data
        li a2, 20            # size
        li a7, 63            # syscall read (63)
        ecall
        ret

    write:
        li a0, 1             # file descriptor = 1 (stdout)
        la a1, output        # buffer
        li a2, 20            # size
        li a7, 64            # syscall write (64)
        ecall
        ret

    string_to_int:
        li t0, 0             # contador de caracteres
        li t1, 4             # tamanho da string
        li t2, 10            # multiplicação constante
        li t3, 0             # resultado parcial

        loop:
            beq t0, t1, done     # se t0 == 4, pula para done
            lb t4, 0(a0)         # carrega o caractere da string
            addi t4, t4, -48     # converte o caractere ASCII para o valor numérico
            mul t3, t3, t2       # desloca o número anterior (multiplica por 10)
            add t3, t3, t4       # adiciona o valor do dígito convertido
            addi a0, a0, 1       # avança para o próximo caractere
            addi t0, t0, 1       # incrementa o contador de dígitos
            j loop               # volta para processar o próximo caractere

        done:                    # número convertido
            addi a0, a0, 1
            mv s3, t3            # armazena o número na memória
            ret
        
    raiz_quadrada: 
        li t0, 0             # contador de iterações
        li t1, 10            # número de iterações
        li t6, 1       
        srl t2, s3, t6        # divide o número por 2
        loop_2:
            beq t0, t1, done_2     # se t0 == 10, pula para done_2
            divu t3, s3, t2        # divide o número pelo chute
            add t2, t2, t3         # soma o chute com o resultado da divisão
            srl t2, t2, t6         # divide o resultado por 2
            addi t0, t0, 1         # incrementa o contador de iterações
            j loop_2               # volta para a próxima iteração
        
        done_2:                    # raiz quadrada
            mv s4, t2              # armazena o valor na memória
            ret

    int_to_string:
        li t0, 10            # constante de divisão
        li t1, 1000          # maior divisor
        li t2, 4             # número de dígitos
        addi t3, s4, 0       # carrega o número
        loop_conversao:
            beqz t2, done_3    # se t2 == 0, pula para done_3
            divu t4, t3, t1    # divide o número pelo maior divisor
            addi t4, t4, 48    # converte o valor numérico para ASCII
            sb t4, 0(s5)       # armazena o caractere na string
            rem t3, t3, t1     # t3 = t3 % 10^n (último dígito)
            divu t1, t1, t0    # divide o maior divisor por 10
            addi s5, s5, 1     # avança para o próximo caractere
            addi t2, t2, -1    # decrementa o contador de dígitos
            j loop_conversao   # volta para processar o próximo dígito

        done_3:                # string convertida
            li t5, ' '
            sb t5, 0(s5)
            addi s5, s5, 1
            ret

    _start:
        jal ra, read
        la a0, input         #carrega o endereço da string em a0
        li s7, 0             #contador de números extraídos
        li s8, 4             #quantidade de numeros
        la s5, output        # endereço da string

        loop_main:
            beq s7, s8, done_5  #se s7 == 4, pula para done_5
            jal ra, string_to_int
            jal ra, raiz_quadrada
            jal ra, int_to_string
            addi s7, s7, 1       #incrementa o contador de números extraídos
            j loop_main          #volta para processar o próximo grupo de números

        done_5:
            la a0, output
            li t5, '\n'
            sb t5, 19(a0)
        
        jal ra, write

        li a0, 0
        li a7, 93            # Código da syscall exit
        ecall