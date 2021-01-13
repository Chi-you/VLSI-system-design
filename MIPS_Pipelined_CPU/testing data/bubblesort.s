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
subu  $2,$9,$7 // L10
addiu $2,$2,-1
blez  $2,.L14<addr:35>
move  $5,$0
subu  $2,$9,$7
addiu $6,$2,-1
sll   $2,$5,2
addu  $4,$2,$8 // L15
lw    $2,4($4)
lw    $3,0($4)
slt   $2,$2,$3
beq   $2,$0,.L7<addr:31>
nop
lw    $3,0($4)
lw    $2,4($4)
sw    $2,0($4)
sw    $3,4($4)
addiu $5,$5,1  // L7
slt   $2,$5,$6
sll   $2,$2,2
bne   $2,$0,.L15<addr:21>
addiu $7,$7,1  // L14
slt   $2,$7,$10
bne   $2,$0,.L10<addr:14>
move  $2,$0
j     $31      // jr ra
nop

