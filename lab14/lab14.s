.data
    _system_time: .word 0
    program_stack: .skip 1024
    isr_stack: .skip 1024

.text
.globl _start
.globl play_note

main_isr:
    # Salvando o contexto
    csrrw sp, mscratch, sp
    addi sp, sp, -64
    sw a0, 0(sp)
    sw a1, 4(sp)

    # Causa da interrupção
    csrr a1, mcause
    bgez a1, exception_handler
    andi a1, a1, 0x7f
    li a2, 11                      # codigo para interrupção externa 
    bne a1, a2, not_external_interruption
    jal external_isr

    # Restaurando o contexto
    lw a0, 0(sp)
    lw a1, 4(sp)
    addi sp, sp, 64
    csrrw sp, mscratch, sp
    mret

external_isr:


play_note:
    li t0, 4294902528   
    mv t0, a0                       # t0 = channel
    li t1, 2
    addi t1, t1, t0                 # t1 = base + 2
    mv t1, a1                       # t1 = instrument id
    li t1, 4
    addi t1, t1, t0                 # t1 = base + 4
    mv t1, a2                       # t1 = note
    li t1, 5
    addi t1, t1, t0                 # t1 = base + 5
    mv t1, a3                       # t1 = velocity
    li t1, 6
    addi t1, t1, t0                 # t1 = base + 6
    mv t1, a4                       # t1 = duration

_start: 
    # Inicializando a pilha
    la sp, program_stack
    addi sp, sp, 1024

    # Registrando a ISR 
    la t0, main_isr
    csrw mtvec, t0

    # Configurando o mscratch
    la t0, isr_stack    
    addi t0, t0, 1024
    csrw mscratch, t0

    # Configurar perifericos 
    

    # Habilitar interrupções
    csrr t1, mie
    li t2, 0x800
    or t1, t1, t2
    csrw mie, t1

    jal main