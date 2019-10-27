addi r1, r0, 100
startloop:
add r3, r3, r1
subi r1, r1, 1
nop
nop
bnez r1, startloop
end:
j end


