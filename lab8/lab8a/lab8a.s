.data
    input_file: .asciz "image.pgm"
    input_text: .skip 262159

.text
.globl _start 
    open:
        la a0, input_file    # address for the file path
        li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
        li a2, 0             # mode
        li a7, 1024          # syscall open
        ecall
        ret

    read:
        la a1, input_text         # buffer to write the data
        li a2, 262159             # size
        li a7, 63                 # syscall read (63)
        ecall
        ret

    close:
        li a0, 3             # file descriptor (fd) 3
        li a7, 57            # syscall close
        ecall
        ret

    setCanvaSize:
        addi a0, s1, 0                           # width
        addi a1, s2, 0                           # height
        li a7, 2201                              # syscall setCanvasSize (2201)
        ecall
        ret
    
    setPixel:
        addi a0, s3, 0                           # x coordinate
        addi a1, s4, 0                           # y coordinate
        addi a2, s5, 0                           # color
        li a7, 2200                              # syscall setPixel (2200)
        ecall
        ret

    getWidth:
        la s0, input_text
        addi s0, s0, 3                           # começo do numero Width
        li t2, 0                                 # t2 -> 0 (resultado parcial)
        loop_getWidth: 
            lb t0, 0(s0)                         # t0 -> caractere
            li t1, ' '                           # t1-> ' '
            beq t0, t1, end_loop_getWidth        # fim do numero de width
            addi t0, t0, -48                     # t1 -> valor numerico
            li t1, 10                            # t1 -> 10 (multiplicador)
            mul t2, t2, t1                       # multiplica o resultado parcial por 10
            add t2, t2, t0                       # soma o valor unitario no resultado paarcial
            addi s0, s0, 1                       # avança no buffer 
            j loop_getWidth                      # retorna ao loop

        end_loop_getWidth:
            addi s0, s0, 1                       # avança no buffer
            mv s1, t2                            # s1 -> width
            ret

    getHeight:
        li t2, 0                                 # t2 -> 0 (resultado parcial)
        loop_getHeight: 
            lb t0, 0(s0)                         # t0 -> caractere
            li t1, '\n'                          # t1-> '\n'
            beq t0, t1, end_loop_getHeight       # fim do numero de height
            addi t0, t0, -48                     # t1 -> valor numerico
            li t1, 10                            # t1 -> 10 (multiplicador)
            mul t2, t2, t1                       # multiplica o resultado parcial por 10
            add t2, t2, t0                       # soma o valor unitario no resultado paarcial
            addi s0, s0, 1                       # avança no buffer 
            j loop_getHeight                     # retorna ao loop

        end_loop_getHeight:
            addi s0, s0, 5                       # avança no buffer
            mv s2, t2                            # s2 -> height
            ret

    get_color: 
        li t0, 0                                # t0 -> 0 (resultado parcial)
        lbu t1, 0(s0)                           # t1 -> caractere
        sll t2, t1, 24                          # desloca o valor para a posição correta (24)
        or t0, t0, t2                           # adiciona o valor ao resultado parcial
        sll t2, t1, 16                          # desloca o valor para a posição correta (16)
        or t0, t0, t2                           # adiciona o valor ao resultado parcial
        sll t2, t1, 8                           # desloca o valor para a posição correta (8)
        or t0, t0, t2                           # adiciona o valor ao resultado parcial
        li t1, 255                              # t1 -> 255
        or t0, t0, t1                           # adiciona o valor ao resultado parcial
        mv s5, t0                               # s5 -> cor
        ret

    _start:
        jal ra, open
        jal ra, read
        jal ra, getWidth
        jal ra, getHeight
        li s3, 0                                 # s3 -> 0 (X)
        li s4, 0                                 # s4 -> 0 (Y)
        loop_Y:
            beq s4, s2, end_loop_Y               # se Y == height
            j loop_X
            loop_X:
                beq s3, s1, end_loop_X           # se X == width
                jal ra, get_color                # pega a cor
                jal ra, setPixel                 # desenha o pixel
                addi s0, s0, 1                   # avança no buffer
                addi s3, s3, 1                   # avança no X
                j loop_X                         # retorna ao loop
            
            end_loop_X:
                li s3, 0                         # s3 -> 0 (X)
                addi s4, s4, 1                   # avança no Y  
                j loop_Y                         # retorna ao loop

        end_loop_Y:
            jal ra, close
            jal ra, setCanvaSize
            li a0, 0
            li a7, 93                            # Código da syscall exit
            ecall
    
            

