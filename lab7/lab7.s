.data
    input1: .asciz "1001\n"
    input2: .asciz "0011001\n"
    output1: .skip 8
    output2: .skip 5
    output3: .skip 2
    p1: .byte 0
    p2: .byte 0
    p3: .byte 0
    d1: .byte 0
    d2: .byte 0
    d3: .byte 0
    d4: .byte 0
    
.text
.globl _start
    read1:
        li a0, 0             # file descriptor = 0 (stdin)
        la a1, input1        # buffer to write the data
        li a2, 5            # size
        li a7, 63            # syscall read (63)
        ecall
        ret

    read2:
        li a0, 0             # file descriptor = 0 (stdin)
        la a1, input2        # buffer to write the data
        li a2, 8             # size
        li a7, 63            # syscall read (63)
        ecall
        ret

    write1:
        li a0, 1             # file descriptor = 1 (stdout)
        la a1, output1       # buffer
        li a2, 8             # size
        li a7, 64            # syscall write (64)
        ecall
        ret
    
    write2:
        li a0, 1             # file descriptor = 1 (stdout)
        la a1, output2       # buffer
        li a2, 5             # size
        li a7, 64            # syscall write (64)
        ecall
        ret

    write3:
        li a0, 1             # file descriptor = 1 (stdout)
        la a1, output3       # buffer
        li a2, 2             # size
        li a7, 64            # syscall write (64)
        ecall
        ret

    _start:
        jal ra, read1
        jal ra, read2

        la s10, input1
        la s11, input2
        la s9, output1
        la s8, output2

        lb t0, 0(s10)        # t0 -> d1
        lb t1, 1(s10)        # t1 -> d2
        lb t2, 2(s10)        # t2 -> d3
        lb t3, 3(s10)        # t3 -> d4
        sb t0, 2(s9)         # d1 -> output1[2]
        sb t1, 4(s9)         # d2 -> output1[4]
        sb t2, 5(s9)         # d3 -> output1[5]
        sb t3, 6(s9)         # d4 -> output1[6]
        xor t4, t0, t1
        xor t4, t4, t3
        sb t4, 0(s9)         # p1 -> output1[0]
        xor t4, t0, t2
        xor t4, t4, t3
        sb t4, 1(s9)         # p2 -> output1[1]
        xor t4, t1, t2
        xor t4, t4, t3
        sb t4, 3(s9)         # p3 -> output1[3]
        li t4, '\n'
        sb t4, 7(s9)         # '\n' -> output1[7]

        lb t0, 2(s11)        # t0 -> d1
        lb t1, 4(s11)        # t1 -> d2
        lb t2, 5(s11)        # t2 -> d3
        lb t3, 6(s11)        # t3 -> d4
        sb t0, 0(s8)         # d1 -> output2[0]
        sb t1, 1(s8)         # d2 -> output2[1]
        sb t2, 2(s8)         # d3 -> output2[2]
        sb t3, 3(s8)         # d4 -> output2[3]
        li t4, '\n'
        sb t4, 4(s8)         # '\n' -> output2[4]

        lb t0, 0(s11)        # t0 -> p1
        lb t1, 2(s11)        # t1 -> d1
        lb t2, 4(s11)        # t2 -> d2
        lb t3, 6(s11)        # t3 -> d4
        xor s1, t0, t1       # s1 -> p1 | d1
        xor s1, s1, t2       # s1 -> p1 | d1 | d2
        xor s1, s1, t3       # s1 -> p1 | d1 | d2 | d4

        lb t0, 1(s11)        # t0 -> p2
        lb t1, 2(s11)        # t1 -> d1
        lb t2, 5(s11)        # t2 -> d3
        lb t3, 6(s11)        # t3 -> d4
        xor s2, t0, t1       # s2 -> p2 | d1
        xor s2, s2, t2       # s2 -> p2 | d1 | d3
        xor s2, s2, t3       # s2 -> p2 | d1 | d3 | d4

        lb t0, 3(s11)        # t0 -> p3
        lb t1, 4(s11)        # t1 -> d2
        lb t2, 5(s11)        # t2 -> d3
        lb t3, 6(s11)        # t3 -> d4
        xor s3, t0, t1       # s3 -> p3 | d2
        xor s3, s3, t2       # s3 -> p3 | d2 | d3
        xor s3, s3, t3       # s3 -> p3 | d2 | d3 | d4

        or t4, s1, s2        
        or t4, t4, s3
        la s7, output3
        addi t4, t4, 48
        sb t4, 0(s7)         # p1 | p2 | p3 -> output3[0]
        li t5, '\n'
        sb t5, 1(s7)         # '\n' -> output3[1]

        jal ra, write1
        jal ra, write2
        jal ra, write3

        li a0, 0
        li a7, 93            # Código da syscall exit
        ecall
