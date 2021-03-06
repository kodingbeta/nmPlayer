    #include "../c/voWMVDecID.h"
    .include "wmvdec_member_arm.h"
    .include "xplatform_arm_asm.h"

    @AREA WMV9_IDCT, CODE, READONLY
     .text 
     .align 4
    
    .if WMV_OPT_IDCT_ARM == 1

    .globl  _g_IDCTDec_WMV3
		
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @AREA |.text|, CODE, READONLY
    WMV_LEAF_ENTRY g_IDCTDec_WMV3
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	
.set Tmp_Buff_Size						,		32 * 4
.set OFFSET_piDst						,		Tmp_Buff_Size + 0
.set OFFSET_iOffsetToNextRowForDCT		,		Tmp_Buff_Size + 4
.set Statck_Size							,		Tmp_Buff_Size + 8

    stmdb     sp!, {r4 - r12, lr}
    FRAME_PROFILE_COUNT
		
    sub     sp, sp, #Statck_Size
    
    str		r0, [sp, #OFFSET_piDst]	
    str		r1, [sp, #OFFSET_iOffsetToNextRowForDCT]
    
	@ r2== rgiCoefRecon
    mov		r1, sp		@Tmp buff addr
    mov		r0, #4		@loop num
    mov     r4,  #4

Loop1_Start:

@for ( i == 0@ i < (BLOCK_SIZE>>1)@ i++,  blk32 +== 8){

@zeroth stage
@
@x4 == piSrc0[ i +1*4 ]
@x5 == piSrc0[ i +7*4 ]
@y3 == x4 + x5
@x8 == W3 * y3
@x4a == x8 - W3pW5 * x5
@x5a == x8 - W3_W5 * x4

    ldr     r8, [r2, #16]           @ x4 == [4]
    ldr     r9, [r2, #112]          @ x5 == [28*4]
    ldr     r6, [r2, #80]           @ x6
    ldr     r7, [r2, #48]           @ x7
    add     lr, r8, r9              @ y3
   
    rsb     r10, lr, lr, asl #4     @ x8 == 15*y3
    sub     r11, r10, r9, asl #4    @ x4a == x8 - 16 * x5
    sub     r11, r11, r9, asl #3    @          - 8 * x5
    sub     r12, r10, r8, asl #2    @ x5a == x8 - 4 * x4
    sub     r12, r12, r8, asl #1    @          - 2 * x4
@
@x8 == W7 * y3@          //4
@x4 == x8 + W1_W7 * x4@  //12
@x5 == x8 - W1pW7 * x5@  //20

    mov     r10, lr, asl #2         @ x8 == W7(4) * y3
    add     lr,  r10, r8, asl #3    @ x4 == x8 + 8 * x4
    add     r8,  lr,  r8, asl #2    @         + 4 * x4
    
@
@first stage
@   r8 == x4     r9 == x5     r11 == x4a   r12 == x5a

@x7 == piSrc0[ i +3*4 ]
@x6 == piSrc0[ i +5*4 ]

    
    sub     lr,  r10, r9, asl #4    @ x5 == x8 - 16 * x5
    sub     r9,  lr,  r9 ,asl #2    @         -  4 * x5

@y3 == x6 + x7@
@x8 == W7 * y3@          //4
@x4a -== x8 + W1_W7 * x6@ //12
@x5a +== x8 - W1pW7 * x7@    //20

    adds    lr, r6, r7              @ x6+x7
@    mov     r10, lr, asl #2         @ x8 == 4 * y3
    addne   r12, r12, lr, asl #2
    subne   r11, r11, lr, asl #2
    sub     r11, r11, r6, asl #3
    sub     r11, r11, r6, asl #2    @ x4a -== x8 + W1_W7 * x6
    sub     r12, r12, r7, asl #4
    sub     r12, r12, r7, asl #2    @ x5a +== x8 - W1pW7 * x7

@x8 == W3 * y3@          //15
@x4 +== x8 - W3_W5 * x6@ //6
@x5 +== x8 - W3pW5 * x7@ //24

    rsbs    r10, lr, lr, asl #4     @ x8 == 15 * y3
    addne   r8,  r8, r10            @ x4 +== x8 - W3_W5 * x6
    sub     r8,  r8, r6, asl #2
@
@second stage
@

@x0 == piSrc0[ i +0*4 ]@ /* for proper rounding */
@x1 == piSrc0[ i +4*4 ]@
@x1 == x1 * W0@  //12
@x0 == x0 * W0 + (4+(4<<16))@ /* for proper rounding */
@x8 == x0 + x1@
@x0 -== x1@

    ldr     lr, [r2], #4            @ x0 == r6
    sub     r8,  r8, r6, asl #1
    addne   r9,  r9, r10            @ x5 +== x8 - W3pW5 * x7
    add     r6, r4, lr, asl #2      @ x0*4+(4+(4<<16))
    add     r6, r6, r4, lsl #16
    add     r6, r6, lr, asl #3      @     +x0*8

    ldr     lr, [r2, #60]           @ x1 == r7
    sub     r9,  r9, r7, asl #4
    sub     r9,  r9, r7, asl #3
    movs    r7, lr, asl #2          
    addnes  r7, r7, lr, asl #3

@r6==x0  r10 == x8
    add     r10, r6, r7             @ x8 == x0 + x1

@x3 == piSrc0[ i +2*4 ]@
@x2 == piSrc0[ i +6*4 ]@     
@x1 == x2@
@x2 == W6 * x3 - W2 * x2@  //6,  16
@x3 == W6 * x1 + W2A * x3@ //6,  16

    ldr     lr, [r2, #28]           @ x3
    subne   r6, r6, r7              @ x0
    ldr     r7, [r2, #92]           @ x2

@r5 == x2
    movs    r5, lr, asl #2          @ 4*x3
    addne   r5, r5, lr, asl #1      @ 6 * x3
    sub     r5, r5, r7, asl #4      @  - 16 * x2

@r7 == x3
    movne   lr, lr, asl #4          @ 16*x3
    add     lr, lr, r7, asl #2      @ 4*x2+16*x3
    adds    r7, lr, r7, asl #1      @ 6 * x2 + 16 * x3
@
@third stage
@  lr==x7   r10==x8  r7==x3      r6==x0
@
@x7 == x8 + x3@
@x8 -== x3@
@x3 == x0 + x2@
@x0 -== x2@

    add     lr, r10, r7             @ x7 == x8 + x3
    subne   r10, r10, r7
    add     r7, r6, r5
    sub     r6, r6, r5

@ store blk32[0], blk32[4]
@  lr==x7   r10==x8  r7==x3      r6==x0
@  r8==x4   r9==x5   r11==x4a    r12==x5a
@

@b0 == x7 + x4@
@b1 == (b0 + 0x8000)>>19@
@b0 == ((I16_WMV)b0)>>3@

@c0 == x3 + x4a@
@c1 == (c0 + 0x8000)>>19@
@c0 == ((I16_WMV)c0)>>3@

    add     lr, lr, r8              @ b0 == x7 + x4
    sub     r8, lr, r8, asl #1      @ cn0 == x7 - x4
    add     r7, r7, r11             @ c0 == x3 + x4a
    
    add     r5, lr, r4, lsl #13     @ b1 == b0+0x8000
    movs    lr, lr, lsl #16
    sub     r11, r7, r11, asl #1    @ bn0 == x3 - x4a
    movne   lr, lr, asr #19
    add     r4, r7, r4, lsl #13     @ c1 == c0+0x8000
    mov     r7, r7, lsl #16
    
    mov     r4, r4, asr #19
    mov     r7, r7, asr #19
    
    mov     r4, r4, asl #16
    add     r4, r4, r5, asr #19     @ (c1<<16) + b1
    str     r4, [r1, #16]           @ blk32[4]

@ store blk32[3], blk32[7]
@   r11==b0  r8==c0  lr,r7,r5,r4 free

    mov     r4, #4
    add     r7, lr, r7, asl #16     @ (c0<<16) + b0
    adds    lr, r11, r4, lsl #13    
    str     r7, [r1]                @ blk32[0]
    movne   lr, lr, asr #19         @ b1 == (b0 + 0x8000)>>19
    movs    r11, r11, lsl #16
    add     r6,  r6, r12            @ b0 == x0+x5a
    movne   r11, r11, asr #19       @ ((I16_WMV)b0)>>3

    adds    r7, r8, r4, lsl #13    
    sub     r12, r6, r12, asl #1    @ cn0== x0-x5a
    movne   r7, r7, asr #19         @ c1 == (c0 + 0x8000)>>19
    movs    r8, r8, lsl #16
    add     r7, lr, r7, asl #16     @ blk32[7] == (c1<<16) + b1
    movne   r8, r8, asr #19         @ ((I16_WMV)c0)>>3
    
    
@ store blk32[1], blk32[5]
@   r6==x0   r12==x5a r10==x8  r9==x5
    
    adds    lr, r6, r4, lsl #13    
    add     r10, r10, r9            @ c0 == x8+x5
    movne   lr, lr, asr #19         @ b1 == (b0 + 0x8000)>>19
    movs    r6, r6, lsl #16
    sub     r9,  r10, r9, asl #1    @ bn0== x8-x5
    movne   r6, r6, asr #19       @ ((I16_WMV)b0)>>3
    
    adds    r5, r10, r4, lsl #13    
    add     r8, r11, r8, asl #16    @ blk32[3] == (c0<<16) + b0
    movne   r5, r5, asr #19         @ c1 == (c0 + 0x8000)>>19
    movs    r10, r10, lsl #16
    str     r8, [r1, #12]
    movne   r10, r10, asr #19         @ ((I16_WMV)c0)>>3
    str     r7, [r1, #28]
    add     r5, lr, r5, asl #16     @ blk32[7] == (c1<<16) + b1
                
@ store blk32[2], blk32[6]

    adds    lr, r9, r4, lsl #13    
    add     r6, r6, r10, asl #16    @ blk32[3] == (c0<<16) + b0
    movne   lr, lr, asr #19         @ b1 == (b0 + 0x8000)>>19
    movs    r9, r9, lsl #16
    str     r5, [r1, #20]
    movne   r9, r9, asr #19       @ ((I16_WMV)b0)>>3
    add     r10, r12, r4, lsl #13    
    str     r6, [r1, #4]
    movs    r12, r12, lsl #16
    mov     r10, r10, asr #19         @ c1 == (c0 + 0x8000)>>19
    movne   r12, r12, asr #19         @ ((I16_WMV)c0)>>3
    add     r10, lr, r10, asl #16     @ blk32[7] == (c1<<16) + b1
    add     r9, r9, r12, asl #16    @ blk32[3] == (c0<<16) + b0
    str     r9, [r1, #8]
    str     r10, [r1, #24]

    subs    r0, r0, #1               @ if (i<iNumLoops)
    add     r1,  r1,  #32           @ blk32+==8
    bne     Loop1_Start
@}

    mov		r0, sp						@Tmp buff addr
    ldr		r1, [sp, #OFFSET_piDst]		@dst addr
    mov		r2, #4						@loop num
  
@piSrc0 == tmpBuffer@ //piDst->i32@    
@blk0 == piDst@
@blk1 == blk0 + iOffsetToNextRowForDCT@
@blk2 == blk1 + iOffsetToNextRowForDCT@
@blk3 == blk2 + iOffsetToNextRowForDCT@
@blk4 == blk3 + iOffsetToNextRowForDCT@
@blk5 == blk4 + iOffsetToNextRowForDCT@
@blk6 == blk5 + iOffsetToNextRowForDCT@
@blk7 == blk6 + iOffsetToNextRowForDCT@
    
Loop2_Start:

@for (i == 0@ i < (BLOCK_SIZE>>1)@ i++){

@x4 == piSrc0[i + 1*4 ]@
@x5 == piSrc0[i + 7*4 ]@
@y4a == x4 + x5@
@x8 == 7 * y4a@
@x4a == x8 - 12 * x5@
@x5a == x8 - 3 * x4@
@  zeroth stage

    ldr     r8,  [r0, #16]          @ x4
    ldr     r9,  [r0, #112]         @ x5
    adds    lr,  r8, r9             @ y4a
    rsb     r12, lr, lr, asl #3     @ x8
    sub     r6,  r12, r9, asl #3
    sub     r6,  r6, r9, asl #2     @ x4a
    sub     r7,  r12, r8, asl #1    
    sub     r7,  r7,  r8            @ x5a

@x8 == 2 * y4a@
@x4 == x8 + 6 * x4@
@x5 == x8 - 10 * x5@

    movne   r12, lr, asl #1         @ x8
    add     r4,  r12, r8, asl #2
    add     r8,  r4, r8, asl #1     @ x4
    sub     r4,  r12, r9, asl #3
    sub     r9,  r4,  r9, asl #1    @ x5

@ls_signbit==y4a&0x8000@
@y4a == (y4a >> 1) - ls_signbit@
@y4a == y4a & ~0x8000@
@y4a == y4a | ls_signbit@
@x4a +== y4a@
@x5a +== y4a@

    and     r4,  lr, #0x80, 24		@0x8000
    rsb     lr,  r4, lr, asr #1
    bic     lr,  lr, #0x80, 24
    orrs    lr,  lr, r4             @ y4a

@x6 == piSrc0[i + 5*4 ]@
@x7 == piSrc0[i + 3*4 ]@
@y4 == x6 + x7@
@x8 == 2 * y4@
@x4a -== x8 + 6 * x6@
@x5a +== x8 - 10 * x7@
@  first stage

    ldr     r10, [r0, #80]          @ x6
    ldr     r11, [r0, #48]          @ x7
    addne   r6,  r6, lr             @ x4a
    addne   r7,  r7, lr             @ x5a
    adds    lr,  r10, r11           @ y4
    mov		r3, #32
    rsb     r12, lr, lr, asl #3     @ x8
    subne   r6,  r6, lr, asl #1
    sub     r6,  r6, r10, asl #2
    sub     r6,  r6, r10, asl #1    @ x4a
    addne   r7,  r7, lr, asl #1
    sub     r7,  r7, r11, asl #3
    sub     r7,  r7, r11, asl #1    @ x5a

@x8 == 7 * y4@
@ls_signbit==y4&0x8000@
@y4 == (y4 >> 1) - ls_signbit@
@y4 == y4 & ~0x8000@
@y4 == y4 | ls_signbit@
@x4 +== y4@
@x5 +== y4@
@x4 +== x8 - 3 * x6@
@x5 +== x8 - 12 * x7@

    ands    r4,  lr, #0x80, 24
    rsb     lr,  r4, lr, asr #1
    bic     lr,  lr, #0x80, 24
    orrnes  lr,  lr, r4             @ y4
    adds    r12, r12, lr           @ y4+x8
@
@ second stage
@
@x0 == piSrc0[i + 0*4 ] * 6 + 32 + (32<<16) /* rounding */@
@x1 == piSrc0[i + 4*4 ] * 6@
@x8 == x0 + x1@
@x0 -== x1@
@x2 == piSrc0[i + 6*4 ]@
@x3 == piSrc0[i + 2*4 ]@
@x1 == 8 * (x2 + x3)@
@x6 == x1 - 5 * x2@
@x1 -== 11 * x3@

    ldr     lr,  [r0], #4
    addne   r8,  r8, r12
    addne   r9,  r9, r12
    add     r4,  r3, r3, lsl #16
    add     r4,  r4, lr, asl #2
    add     r4,  r4, lr, asl #1     @ x0

    ldr     lr,  [r0, #60]          @ [4*4]
    sub     r8,  r8, r10, asl #1
    sub     r8,  r8, r10            @ x4
    sub     r9,  r9, r11, asl #3
    adds    lr,  lr, lr, asl #1      
    ldr     r5,  [r0, #28]          @ x3
    add     r12, r4, lr, asl #1     @ x8
    subne   r4,  r4, lr, asl #1     @ x0

    ldr     lr,  [r0, #92]          @ x2
    sub     r9,  r9, r11, asl #2    @ x5
    add     r11, lr, lr, asl #1     @ 3*x2
    adds    r10, r11, r5, asl #3    @ x6
    sub     r11, r5,  r5, asl #2     @ -3*x3
    add     r5,  r11, lr, asl #3    @ x1

@ third stage
@x7 == x8 + x6@
@x8 -== x6@
@x6 == x0 - x1@
@x0 +== x1@

    add     r11,  r12, r10          @ x7
    subne   r12,  r12, r10          @ x8
    sub     r10,  r4, r5            @ x6
    add     r4,   r4, r5            @ x0
@
@r4==x0 r6==x4a r7==x5a r8==x4 r9==x5 r10==x6 r11==x7 x12==x8 
@r3, r5, lr are free. 
@here set r3==iOffsetToNextRowForDCT. r5, lr are temp.
@

@j == i<<1@
	
	
@// blk0
@b0 == (x7 + x4)@
@b1 == (b0 + 0x8000)>>22@
@b0 == ((I16_WMV)b0)>>6@
@blk0[ j ] == SATURATE8(b0)@
@blk0[ j+1] == SATURATE8(b1)@

    adds    r5,  r11, r8            @ b0
    add     lr,  r5,  #0x80, 24		@0x8000
    movne   r5,  r5,  asl #16
    mov     lr,  lr,  asr #22       @ b1    
    movne   r5,  r5,  asr #22       @ b0
   
    bics    r3, r5, #0xFF
    mvnne   r5, r5, asr #31
    bics    r3, lr, #0xFF
    mvnne   lr, lr, asr #31
    strb    r5, [r1]
    strb    lr, [r1, #1]

@// blk7
@b0 == (x7 - x4)@
@b1 == (b0 + 0x8000)>>22@
@b0 == ((I16_WMV)b0)>>6@
@blk7[ j ] == SATURATE8(b0)@
@blk7[ j+1] == SATURATE8(b1)@

	ldr		r3, [sp, #OFFSET_iOffsetToNextRowForDCT]

    subs    r11, r11, r8          @ b0
    add     lr, r11, #0x80, 24
    movne   r11, r11, asl #16
    mov     lr, lr, asr #22      @ b1  
    movne   r11, r11, asr #22    @ b0
    
    bics    r5, r11, #0xFF
    mvnne   r11, r11, asr #31
    bics    r5, lr, #0xFF
    mvnne   lr, lr, asr #31
    
    rsb		r5, r3, r3, lsl #3
    add		r5, r5, r1
    strb    r11, [r5]
    strb    lr, [r5, #1]
    
@// blk1
@b0 == (x6 + x4a)@
@b1 == (b0 + 0x8000)>>22@
@b0 == ((I16_WMV)b0)>>6@
@blk1[ j ] == SATURATE8(b0)@
@blk1[ j+1] == SATURATE8(b1)@

    adds    r5,  r10, r6            @ b0
    add     lr,  r5,  #0x80, 24
    movne   r5,  r5,  asl #16
    mov     lr,  lr,  asr #22       @ b1
    movne   r5,  r5,  asr #22       @ b0
    
    bics    r8, r5, #0xFF
    mvnne   r5, r5, asr #31
    bics    r8, lr, #0xFF
    mvnne   lr, lr, asr #31
    
    add		r8, r3, r1
    strb    r5,  [r8]    
    strb    lr,  [r8, #1]

@// blk6
@b0 == (x6 - x4a)@
@b1 == (b0 + 0x8000)>>22@
@b0 == ((I16_WMV)b0)>>6@
@blk6[ j ] == SATURATE8(b0)@
@blk6[ j+1] == SATURATE8(b1)@

    subs    r11, r10, r6     
    add     lr,  r11, #0x80, 24
    movne   r11,  r11,  asl #16
    mov     lr,  lr,  asr #22      @ b1
    movne   r11,  r11,  asr #22    @ b0
    
    bics    r8, r11, #0xFF
    mvnne   r11, r11, asr #31
    bics    r8, lr, #0xFF
    mvnne   lr, lr, asr #31
    
    add		r8, r1, r3, lsl #2
    add		r8, r8, r3, lsl #1
    strb    r11,  [r8]    
    strb    lr,  [r8, #1]

@// blk2
@b0 == (x0 + x5a)@
@b1 == (b0 + 0x8000)>>22@
@b0 == ((I16_WMV)b0)>>6@
@blk2[ j ] == SATURATE8(b0)@
@blk2[ j+1] == SATURATE8(b1)@

    adds    r5,  r4, r7            @ b0
    add     lr,  r5,  #0x80, 24
    movne   r5,  r5,  asl #16
    mov     lr,  lr,  asr #22       @ b1
    movne   r5,  r5,  asr #22       @ b0

    bics    r8, r5, #0xFF
    mvnne   r5, r5, asr #31
    bics    r8, lr, #0xFF
    mvnne   lr, lr, asr #31
    
    add		r8, r1, r3, lsl #1
    strb    r5,  [r8]    
    strb    lr,  [r8, #1]

@// blk5
@b0 == (x0 - x5a)@
@b1 == (b0 + 0x8000)>>22@
@b0 == ((I16_WMV)b0)>>6@
@blk5[ j ] == SATURATE8(b0)@
@blk5[ j+1] == SATURATE8(b1)@

    subs    r11, r4, r7     
    add     lr,  r11, #0x80, 24
    movne   r11,  r11,  asl #16
    mov     lr,  lr,  asr #22      @ b1
    movne   r11,  r11,  asr #22    @ b0
    
    bics    r8, r11, #0xFF
    mvnne   r11, r11, asr #31
    bics    r8, lr, #0xFF
    mvnne   lr, lr, asr #31
    
    add		r8, r3, r3, lsl #2
    add		r8, r8, r1
    strb    r11,  [r8]    
    strb    lr,  [r8, #1]
    
@// blk3
@b0 == (x8 + x5)@
@b1 == (b0 + 0x8000)>>22@
@b0 == ((I16_WMV)b0)>>6@
@blk3[ j ] == SATURATE8(b0)@
@blk3[ j+1] == SATURATE8(b1)@

    adds    r5,  r12, r9            @ b0
    add     lr,  r5,  #0x80, 24
    movne   r5,  r5,  asl #16
    mov     lr,  lr,  asr #22       @ b1
    movne   r5,  r5,  asr #22       @ b0

    bics    r8, r5, #0xFF
    mvnne   r5, r5, asr #31
    bics    r8, lr, #0xFF
    mvnne   lr, lr, asr #31
    
    rsb		r8, r3, r3, lsl #2
    add		r8, r8, r1
    strb    r5, [r8]
    strb    lr, [r8, #1]
    

@// blk4
@b0 == (x8 - x5)@
@b1 == (b0 + 0x8000)>>22@
@b0 == ((I16_WMV)b0)>>6@
@blk4[ j ] == SATURATE8(b0)@
@blk4[ j+1] == SATURATE8(b1)@

    subs    r11, r12, r9     
    add     lr,  r11, #0x80, 24
    movne   r11,  r11,  asl #16
    mov     lr,  lr,  asr #22      @ b1
    movne   r11,  r11,  asr #22    @ b0
    
    bics    r8, r11, #0xFF
    mvnne   r11, r11, asr #31
    bics    r8, lr, #0xFF
    mvnne   lr, lr, asr #31
    
    add		r8, r1, r3, lsl #2
    strb    r11, [r8]
    strb    lr, [r8, #1]

    subs    r2, r2, #1               @ if (i<iNumLoops)
    add     r1, r1, #2
    bne     Loop2_Start
@}

    add     sp, sp, #Statck_Size
    ldmia   sp!, {r4 - r12, pc}
	
    WMV_ENTRY_END
    @ENDP  @ |g_IDCTDec_WMV3|  

    
	.align 8	
Pass1_table:
		.word 15,12,24,20,6,4				
	.align 8	
Pass2_table:
		.word -3,6,-5,7,-11,-10,-12,-6				
	.align 8	
Pass3_table:	
		.word 10,17,-32,12		

    .endif @ .if WMV_OPT_IDCT_ARM == 1

    @@.end 
