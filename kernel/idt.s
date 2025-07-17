.global idt_flush

.extern isr_handler_c

idt_flush:
    movl 4(%esp), %eax
    lidt (%eax)
    ret

.macro ISR_STUB_NOERR n
.globl isr\n
isr\n:
    cli
    pushl $\n           # Push interrupt number
    jmp isr_common_stub
.endm

.macro ISR_STUB_ERR n
.globl isr\n
isr\n:
    cli
    pushl $0            # Push dummy error code (CPU already pushed real one)
    pushl $\n           # Push interrupt number
    jmp isr_common_stub
.endm

.globl isr_common_stub
isr_common_stub:
    pusha
    movl %esp, %eax     # Pointer to regs struct
    pushl %eax          # Push pointer argument
    call isr_handler_c
    addl $4, %esp       # Clean up argument
    popa
    addl $8, %esp       # Remove pushed int_no and err_code
    sti
    iret

# Exceptions without error code
ISR_STUB_NOERR 0
ISR_STUB_NOERR 1
ISR_STUB_NOERR 2
ISR_STUB_NOERR 3
ISR_STUB_NOERR 4
ISR_STUB_NOERR 5
ISR_STUB_NOERR 6
ISR_STUB_NOERR 7
ISR_STUB_ERR 8          # Double Fault (has error code)
ISR_STUB_NOERR 9
ISR_STUB_ERR 10         # Invalid TSS
ISR_STUB_ERR 11         # Segment Not Present
ISR_STUB_ERR 12         # Stack-Segment Fault
ISR_STUB_ERR 13         # General Protection Fault
ISR_STUB_ERR 14         # Page Fault
ISR_STUB_NOERR 15
ISR_STUB_NOERR 16
ISR_STUB_ERR 17         # Alignment Check
ISR_STUB_NOERR 18
ISR_STUB_NOERR 19
ISR_STUB_NOERR 20
ISR_STUB_NOERR 21
ISR_STUB_NOERR 22
ISR_STUB_NOERR 23
ISR_STUB_NOERR 24
ISR_STUB_NOERR 25
ISR_STUB_NOERR 26
ISR_STUB_NOERR 27
ISR_STUB_NOERR 28
ISR_STUB_NOERR 29
ISR_STUB_NOERR 30
ISR_STUB_NOERR 31
