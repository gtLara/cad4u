addi x10 x0 2
addi x18 x0 3
add x18 x18 x10
blt x0 x10 JUMP
addi x10 x10 -1
JUMP:
nop
nop
nop
nop
addi x10 x10 -10
