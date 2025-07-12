# bootsect.S - Boot sector code for a simple Linux bootloader
# This code is written in assembly language for the x86 architecture.
# It sets up the boot environment and displays a message on the screen.
# It is intended to be assembled with an assembler like NASM or GAS.
# The code is designed to run in real mode and uses BIOS interrupts.

BOOTSEG = 0x7c0


.code16
.text

.global _start
_start:
    jmpl $BOOTSEG, $start2

start2:
    movw $BOOTSEG, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs

    movw $msg, %ax
    movw %ax, %bp
    movw $0x01301, %ax
    movw $0x0c, %bx     #文字是红色
    movw $20, %cx       #显示长度

    movb $0, %dl
    int $0x010          #调用BIOS中断显示字符串

LOOP:
    jmp LOOP    #无限循环

msg:
    .asciz "Hello, Linux World!\n"

.org 510                            #指定当前汇编地址为510
boot_flag:                          #标签，标记引导签名位置
    .Word 0xAA55  # Boot signature  #写入2字节数据：0x55 和 0xAA（小端序）

    


#as -o bootsect.o bootsect.S 
#ld -m elf_x86_64 -Ttext 0x0 -s --oformat binary -o linux.img bootsect.o