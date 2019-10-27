addi r1, r0, 36
nop
nop
jalr r1
sw 1(r0),r1
lw r3,1(r0)
nop
nop
addi r4,r3, 5
end:
j end
