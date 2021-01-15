li $8,536870912
li $9,5
li $2,10
sw $2,0($8)
li $2,92
sw $2,4($8)
li $2,55
sw $2,8($8)
li $2,1
sw $2,12($8)
li $2,46
sw $2,16($8)
move  $7,$0
addiu $10,$9,-1

.L10:
subu  $2,$9,$7 
addiu $2,$2,-1
blez  $2,.L14
move  $5,$0
subu  $2,$9,$7
addiu $6,$2,-1
sll   $2,$5,2

.L15:
addu  $4,$2,$8 
lw    $2,4($4)
lw    $3,0($4)
slt   $2,$2,$3
beq   $2,$0,.L7<addr:31>
nop
lw    $3,0($4)
lw    $2,4($4)
sw    $2,0($4)
sw    $3,4($4)

.L7:
addiu $5,$5,1  
slt   $2,$5,$6
bne   $2,$0,.L15
sll   $2,$2,2

.L14:
addiu $7,$7,1  
slt   $2,$7,$10
bne   $2,$0,.L10
move  $2,$0
j     $31      // jr ra
nop

