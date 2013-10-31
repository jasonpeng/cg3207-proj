ori $1,$0, 0
ori $1,$0, 1
.label2: ori $2,$0, 2
ori $3,$0, 4
ori $4,$0, 8
nop
nop
nop
nor $5,$1,$2
nop
add $6,$1,$2
nop
and $7,$3,$4
nop
sub $8,$4,$3
nop
sw $5, 0
nop
nop
nop
lw $8, 0
nop
nop
nop
j .label
nop
nop
nop
nop
.label:  slt $8, $1, $2
beq $11, $12 .label2
nop
nop
nop