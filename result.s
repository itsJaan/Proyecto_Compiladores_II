.data
.globl main
.text
BubbleSort: 
addiu $sp, $sp, -12

sw $ra, 0($sp)

sw $a0, 4($sp)
sw $a1, 8($sp)
lw $ra, 0($sp)
addiu $sp, $sp, 12
jr $ra
perroBravo: 
addiu $sp, $sp, -8

sw $ra, 0($sp)

sw $a0, 4($sp)
lw $ra, 0($sp)
addiu $sp, $sp, 8
jr $ra
main: 
addiu $sp, $sp, -4

sw $ra, 0($sp)

lw $ra, 0($sp)
addiu $sp, $sp, 4
jr $ra

