.data

.globl main
.text
funcionH: 
addiu $sp, $sp, -8

sw $ra, 0($sp)

li $t0, 1
sw $t0, 4($sp)

lw $ra, 0($sp)

addiu $sp, $sp, 8
jr $ra

main: 
addiu $sp, $sp, -8

sw $ra, 0($sp)

li $t0, 2
sw $t0, 4($sp)

lw $ra, 0($sp)

addiu $sp, $sp, 8
jr $ra


