nop
nop
nop
nop # 0,0 is top left 640, 480 is bottom right
nop
b31: addi $r17, $r0, 240 #initialized middle
addi $r19, $r0, 244 #initialized middle
addi $r1, $r0, 192 #define 192
addi $r2, $r0, 192 #define 192
addi $r3, $r0, 192 #define 192
addi $r4, $r0, 192 #define 192
addi $r5, $r0, 192 #define 192
addi $r6, $r0, 192 #define 192
addi $r7, $r0, 192 #define 192
addi $r8, $r0, 192 #define 192
random $r29
add $r1, $r1, $r29 #get random x value around the middle  #start X position
random $r29
add $r2, $r2, $r29 #get random x value around the middle
random $r29
add $r3, $r3, $r29 #get random x value around the middle
random $r29
add $r3, $r3, $r29 #get random x value around the middle
random $r29
add $r4, $r4, $r29 #get random x value around the middle
random $r29
add $r5, $r5, $r29 #get random x value around the middle
random $r29
add $r6, $r6, $r29 #get random x value around the middle
random $r29
add $r7, $r7, $r29 #get random x value around the middle
random $r29
add $r8, $r8, $r29 #get random x value around the middle # end X position
addi $r9, $r0, 244 # start y position
addi $r18, $r18, 2
addi $r10, $r0, 244
addi $r11, $r0, 244
addi $r12, $r0, 244
addi $r13, $r0, 244
addi $r14, $r0, 244
addi $r15, $r0, 244
addi $r16, $r0, 244
b1: sub $r9, $r9, $r18 # need stall logic around here
j b9
b2: sub $r10, $r10, $r18
j b10
b3: sub $r11, $r11, $r18
j b11
b4: sub $r12, $r12, $r18
j b12
b5: sub $r13, $r13, $r18
j b13
b6: sub $r14, $r14, $r18
j b14
b7: sub $r15, $r15, $r18
j b15
b8: sub $r16, $r16, $r18
b32: nop
bne $r28, $r0, b32 
blt $r17, $r9, b1
b9: blt $r17, $r10, b2
b10: blt $r17, $r11, b3
b11: blt $r17, $r12, b4
b12: blt $r17, $r13, b5
b13: blt $r17, $r14, b6
b14: blt $r17, $r15, b7
b15: blt $r17, $r16, b8
nop
nop
b30: add $r9, $r9, $r18 # need stall logic around here
j b16
b23: add $r10, $r10, $r18
j b17
b24: add $r11, $r11, $r18
j b18
b25: add $r12, $r12, $r18
j b19
b26: add $r13, $r13, $r18
j b20
b27: add $r14, $r14, $r18
j b21
b28: add $r15, $r15, $r18
j b22
b29: add $r16, $r16, $r18 #stall now
b32: nop
bne $r28, $r0, b32 
blt $r17, $r9, b30
b16: blt $r10, $r19, b23
b17: blt $r11, $r19, b24
b18: blt $r12, $r19, b25
b19: blt $r13, $r19, b26
b20: blt $r14, $r19, b27
b21: blt $r15, $r19, b28
b22: blt $r16, $r19, b29 
j b31