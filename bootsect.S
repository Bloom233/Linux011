SETUPLEN = 4    # Length of setup code in sectors   

BOOTSEG = 0x7c0     # Boot sector segment address

INITSEG = 0x9000    # Initial segment address for setup code

SETUPSEG = 0x9020   # Segment address for setup code        

SYSSEG = 0x1000     # System segment address

ENDSEG = SYSSEG + SYSSIZE # End segment address

ROOT_DEV = 0x0000   # Root device number


.code16
.text

.global _start
_start:
    jmpl $BOOTSEG, $start2


start2:
    movw $BOOTSEG, %ax
    movw %ax, %ds
    movw $INITSEG, %ax
    movw %ax, %es
    movw $256, %cx
    subw %si, %si
    subw %di, %di

    rep
    movsw

    jmpl $INITSEG, $go
go:
    movw %cx, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw $0xff00, %sp  # Set stack pointer


load_setup:
    movw $0x0000, %dx
    movw $0x0002, %cx
    movw $0x0200, %bx
    movb $SETUPLEN, %al
    movb $0x02, %ah
    int $0x13          # BIOS interrupt to read sectors
    jnc ok_load_setup
    movw $0x0000, %dx
    movw $0x0000, %ax
    int $0x13          # Retry reading sectors
    jmp load_setup

ok_load_setup:
    movw $msg, %ax
    movw %ax, %bp
    movw $0x01301, %ax  # Function to display string
    movw $0x0c, %bx     # Text color is red
    movw $21, %cx       # Display length
    movb $0, %dl
    int $0x010          # Call BIOS interrupt to display string

    jmpl $SETUPSEG, $0

msg:
    .ascii "Setup code loaded successfully!\n"

.org 508
root_dev:
    .word ROOT_DEV      # Root device number
boot_flag:
    .word 0xAA55        # Boot signature
            

