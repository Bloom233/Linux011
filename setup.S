.code16
.text
.global _start_setup


_start_setup:
    movw %cs, %ax
    movw %ax, %ds
    movw %ax, %es

    movw $setup_msg, %ax
    movw %ax, %bp
    movw $0x01301, %ax  # Function to display string
    movw $0x0c, %bx     # Text color is red
    movw $21, %cx       # Display length
    movb $3, %dh
    movb $0, %dl
    int $0x010          # Call BIOS interrupt to display string

setup_msg:
    .ascii "Setup code loaded successfully!\n"

