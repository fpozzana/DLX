addi r1, r0, 100
nop
nop
nop
sw 1(r0),r1
nop
nop
nop
lw r3,1(r0)
nop
nop
nop
addi r4,r3, 5
end:
j end
j 140
jr r4
jr r1
jal 4
jalr r5
jal #224
jalr r31

