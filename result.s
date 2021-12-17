.data
.globl main
.text
BubbleSort: 
addiu $sp, $sp, -12

sw $ra, 0($sp)

sw $a0, 4($sp)
sw $a1, 8($sp)
li $t0, 3
li $t1, 4
li $t2, 2
li $t3, 6
mult $t2,$t3
mflo $t4
add $t2, $t1,$t4
div $t0,$t2
mflo $t1

lw $ra, 0($sp)

addiu $sp, $sp, 12
jr $ra

main: 
addiu $sp, $sp, -4

sw $ra, 0($sp)

li $t0, 7

lw $ra, 0($sp)

addiu $sp, $sp, 4
jr $ra


