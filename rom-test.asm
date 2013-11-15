.data
0, 1, 2, 3, 4, 5, 6, 7

.text
ori $2, $0, 3
ori $3, $0, 9
add $4, $2, $3
add $4, $4, $2
add $4, $4, $3
lw $5, 4
add $4, $4, $5
sw $4, 8
nop
lw $6, 8
slt $7, $4, $6
slti $8, $2, 4
sll $8, $3, 7
sllv $5, $2, $3
sra $7, $3, 1
srav $7, $3, $2
srl $8, $3, 1
srlv $8, $3, $2