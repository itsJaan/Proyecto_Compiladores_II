.data
string0: .asciiz "holamundo"

.globl main
.text
funcionH: 
addiu $sp, $sp, -8

sw $ra, 0($sp)

sw $a0, 4($sp)
la $a0, string0

lw $ra, 0($sp)

addiu $sp, $sp, 8
jr $ra

main: 
addiu $sp, $sp, -4

sw $ra, 0($sp)

li.s $f0, 2.5
li.s $f1, 5
li $t0, 10
mtc1 $t0, $f2
cvt.s.w $f2, $f2
mul.s $f3, $f1,$f2
add.s $f1, $f0,$f3
li $t0, 1

lw $ra, 0($sp)

addiu $sp, $sp, 4
jr $ra


