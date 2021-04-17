nop
nop
nop
nop # 0,0 is top left 640, 480 is bottom right
nop
addi $r1, $r1, 192 #define 192
addi $r2, $r2, 192 #define 192
addi $r3, $r3, 192 #define 192
addi $r4, $r4, 192 #define 192
addi $r5, $r5, 192 #define 192
addi $r6, $r6, 192 #define 192
addi $r7, $r7, 192 #define 192
addi $r8, $r8, 192 #define 192
addi $r17, $r17, 240 #initialized middle
random $r30
add $r1, $r1, $r30 #get random x value around the middle  #start X position
random $r30
add $r2, $r2, $r30 #get random x value around the middle
random $r30
add $r3, $r3, $r30 #get random x value around the middle
random $r30
add $r3, $r3, $r30 #get random x value around the middle
random $r30
add $r4, $r4, $r30 #get random x value around the middle
random $r30
add $r5, $r5, $r30 #get random x value around the middle
random $r30
add $r6, $r6, $r30 #get random x value around the middle
random $r30
add $r7, $r7, $r30 #get random x value around the middle
random $r30
add $r8, $r8, $r30 #get random x value around the middle # end X position
addi $r9, $r9, 640 # start y position
addi $r10, $r10, 640
addi $r11, $r11, 640
addi $r12, $r12, 640
addi $r13, $r13, 640
addi $r14, $r14, 640
addi $r15, $r15, 640
addi $r16, $r16, 640
b1: addi $r9, $r9, 2 # need stall logic around here
addi $r10, $r10, 2
addi $r11, $r11, 2
addi $r12, $r12, 2
addi $r13, $r13, 2
addi $r14, $r14, 2
addi $r15, $r15, 2
addi $r16, $r16, 2
blt $r17, r10, b1
blt $r17, r11, b1
blt $r17, r12, b1
blt $r17, r13, b1
blt $r17, r14, b1
blt $r17, r15, b1
blt $r17, r16, b1








