.data
    input_coordenadas: .asciz "+0700 -0100\n"
    input_tempos: .asciz "2000 0000 2240 2300\n"
    output: .skip 12
    Ta: .word 0
    Tb: .word 0
    Tc: .word 0
    Tr: .word 0
    Yb: .word 0
    Xc: .word 0
    Ra: .word 0
    Rb: .word 0
    Rc: .word 0
    X: .word 0
    Y: .word 0
    
.text
.globl _start
    write:
        li a0, 1             # file descriptor = 1 (stdout)
        la a1, output        # buffer
        li a2, 20            # size
        li a7, 64            # syscall write (64)
        ecall
        ret

    get_coordenada:
        li t0, 0             # contador de caracteres
        li t1, 4             # tamanho da coordenada
        li t2, 10            # multiplicação constante
        li t3, '+'
        lb t4, 0(s9)
        li a1, 0             # coordenada parcial 

        if:                    # coordenada negativa
            beq t3, t4, else
            li a0, -1
            addi s9, s9, 1     # avança para o próximo caractere
            j loop_coordenada
        else:                  # coordenada positiva
            li a0, 1           
            addi s9, s9, 1     # avança para o próximo caractere
            j loop_coordenada

        loop_coordenada:
            beq t0, t1, done_coordenada   # se t0 == 4, pula para done
            lb t5, 0(s9)       # carrega o caractere da string
            addi t5, t5, -48   # converte o caractere ASCII para o valor numérico
            mul a1, a1, t2     # desloca o número anterior (multiplica por 10)
            add a1, a1, t5     # adiciona o valor do dígito convertido
            addi s9, s9, 1     # avança para o próximo caractere
            addi t0, t0, 1     # incrementa o contador de dígitos
            j loop_coordenada

        done_coordenada:
            mul a1, a1, a0     # multiplica a coordenada pelo sinal
            sw a1, 0(s0)       # armazena a coordenada atual na memória
            addi s9, s9, 1     # avança para o próximo caractere
            ret

    get_tempo:
        li t0, 0             # contador de caracteres
        li t1, 4             # tamanho da string
        li t2, 10            # multiplicação constante
        li t3, 0             # resultado parcial

        loop_tempo:
            beq t0, t1, done_tempo     # se t0 == 4, pula para done
            lb t4, 0(s10)        # carrega o caractere da string
            addi t4, t4, -48     # converte o caractere ASCII para o valor numérico
            mul t3, t3, t2       # desloca o número anterior (multiplica por 10)
            add t3, t3, t4       # adiciona o valor do dígito convertido
            addi s10, s10, 1     # avança para o próximo caractere
            addi t0, t0, 1       # incrementa o contador de dígitos
            j loop_tempo               # volta para processar o próximo caractere

        done_tempo:                    # número convertido
            addi s10, s10, 1
            sw t3, 0(s0)            # armazena o número na memória
            ret

    get_distancia:
        li t0, 0             # diatancia parcial
        lw t1, 0(s0)         # carrega Tr
        lw t2, 0(s1)         # carrega Tx
        li t3, -1
        mul t2, t2, t3       # Tx = -Tx
        add t0, t1, t2       # Tr - Tx
        mul t0, t0, t0       # (Tr - Tx)^2
        li t4, 9
        li t5, 100
        mul t0, t0, t4       # 9*(Tr - Tx)^2
        divu t0, t0, t5      # 9*(Tr - Tx)^2/100
        sw t0, 0(s2)         # armazena a distancia parcial
        ret
        
    int_to_string:
        li t0, 10            # constante de divisão
        li t1, 1000          # maior divisor
        li t2, 4             # número de dígitos
        lw t3, s4            # carrega o número
        if_positivo:
            bltz t3, negativo
            li t4, '+'
            sb t4, 0(s11)
            addi s11, s11, 1
            j loop_conversao
        negativo:
            li t4, '-'
            sb t4, 0(s11)
            addi s11, s11, 1
            li t4, -1
            mul t3, t3, t4
            j loop_conversao

        loop_conversao:
            beqz t2, done_3    # se t2 == 0, pula para done_3
            divu t5, t3, t1    # divide o número pelo maior divisor
            addi t5, t5, 48    # converte o valor numérico para ASCII
            sb t5, 0(s11)      # armazena o caractere na string
            rem t3, t3, t1     # t3 = t3 % 10^n (último dígito)
            divu t1, t1, t0    # divide o maior divisor por 10
            addi s11, s11, 1     # avança para o próximo caractere
            addi t2, t2, -1    # decrementa o contador de dígitos
            j loop_conversao   # volta para processar o próximo dígito

        done_3:                # string convertida
            li t5, ' '
            sb t5, 0(s11)
            addi s11, s11, 1
            ret

    _start:
        la s9, input_coordenadas
        la s0, Yb
        jal get_coordenada
        la s0, Xc
        jal get_coordenada

        la s10, input_tempos
        la s0, Ta
        jal get_tempo
        la s0, Tb
        jal get_tempo
        la s0, Tc
        jal get_tempo
        la s0, Tr
        jal get_tempo

        la s0, Tr
        la s1, Ta
        la s2, Ra
        jal get_distancia
        la s1, Tb
        la s2, Rb
        jal get_distancia
        la s1, Tc
        la s2, Rc
        jal get_distancia

        la s0, Y
        li t0, 0             # coordenada parcial
        la a2, Ra            # t1-> Ra
        lw t1, 0(a2)
        la a3, Rb            # t2-> Rb
        lw t2, 0(a3)
        la a4, Yb            # t3-> Yb
        lw t3, 0(a4)
        li t4, -1
        mul t1, t1 , t4      # Ra = -Ra
        add t0, t2, t1       # Rb - Ra
        mul t5, t3, t3       # Yb^2
        mul t5, t5, t4       # -Yb^2
        add t0, t0, t5       # Rb - Ra - Yb^2
        mul t5, t3, t4       # -Yb
        slli t5, t5, 1       # -2*Yb 
        div t0, t0, t5       # (Rb - Ra - Yb^2)/(-2*Yb)
        sw t0, 0(s0)         # armazena Y

        la s0, X
        li t0, 0             # coordenada parcial
        la a2, Ra            # t1-> Ra
        lw t1, 0(a2)
        la a3, Rc            # t2-> Rc
        lw t2, 0(a3)
        la a4, Xc            # t3-> Xc
        lw t3, 0(a4)
        li t4, -1
        mul t1, t1 , t4      # Ra = -Ra
        add t0, t2, t1       # Rc - Ra
        mul t5, t3, t3       # Xc^2
        mul t5, t5, t4       # -Xc^2
        add t0, t0, t5       # Rc - Ra - Xc^2
        mul t5, t3, t4       # -Xc
        slli t5, t5, 1       # -2*Xc 
        div t0, t0, t5       # (Rc - Ra - Xc^2)/(-2*Xc)
        sw t0, 0(s0)         # armazena X

        la s11, output
        la s4, X
        jal int_to_string
        la s4, Y
        jal int_to_string

        la a0, output
        li t5, '\n'
        sb t5, 11(a0)

        li a0, 0
        li a7, 93            # Código da syscall exit
        ecall

    
    