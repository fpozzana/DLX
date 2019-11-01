addi r2, r0, 4
addi r1, r0, 1
nop
nop
sw 1(r1), r2
lw r3, 1(r1)
nop
nop
addi r5, r3, 6
end:
j end
