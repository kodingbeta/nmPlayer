; generated by ARM/Thumb C/C++ Compiler, RVCT2.2 [Build 349]
; commandline armcc [--c90 --no_debug_macros -c --asm -oH264_D_ARMv4_RVDS_LIB_Data\Release\ObjectCode\Chroma_InPlaceDeblock.o --cpu=ARM920T -O3 -Otime --diag_style=ide -I. -I..\..\..\..\Sources -I..\..\..\..\Sources\ARM9\ARMV4 -I..\..\..\..\..\..\..\..\VOIAPP\common\lib\ARM9\ELF -I..\..\..\..\Sources\IA32\C -I..\..\..\..\..\..\..\..\VOIAPP\common\inc -I"..\..\..\..\Sources\ARM9\for ARMCC" -I..\..\..\..\Sources\ARM9 -J"d:\Program Files\ARM\RVCT\Data\2.2\349\include\windows" -J"d:\Program Files\ARM\RVCT\Data\2.2\349\include\windows" -DNDEBUG -DARM -DARM_ASM -DRVDS --signed_chars --brief_diagnostics D:\source_safe_project\H264Codec\VideoCodec\H264\Decoder\Sources\ARM9\Chroma_InPlaceDeblock.c]

        ;ARM
        ;REQUIRE8
        ;PRESERVE8

        AREA |.text|, CODE, READONLY, ALIGN=2

Chroma_InPlaceDeblock PROC
        ;PUSH     {r0-r11,lr}
		stmfd   r13!, {r0-r11, r14} ;  14_1

        SUB      sp,sp,#4
        LDR      r8,[sp,#0x38]
        LDR      r11,[sp,#0x3c]
        LDR      lr,[sp,#0x40]
        RSB      r8,r8,#0
        MOV      r1,#0
        STR      r8,[sp,#0]
|L1.32|
        LDR      r12,[sp,#8]
        LDRB     r5,[r0,#0]
        LDRB     r6,[r0,r2]
        LDRB     r9,[r12,r1,ASR #1]
        SUB      r10,r0,r2
        SUB      r4,r0,r2,LSL #1
        CMP      r9,#0
        ADDEQ    r1,r1,#1
        STR 	 r1,[sp,#-4]
        ADDEQ    r0,r0,r3
        BEQ      |L1.260|
        
       
        LDRB     r4,[r4,#0]
        LDRB     r12,[r10,#0]
        SUBS     r8,r5,r6
        RSBMI    r8,r8,#0
        SUBS     r7,r12,r4
        RSBMI    r7,r7,#0
        CMP      r8,r11
        CMPLT    r7,r11
        LDRLT    r8,[sp,#0x38]
        LDR      r1,[sp,#0]
        SUBLT    r7,r5,r12
        CMPLT    r7,r8
        BGE      |L1.260|
        
        
        CMP      r7,r1
        BLE      |L1.260|
        CMP      r9,#4
        BEQ      |L1.220|
;        LDR      r1,[sp,#0x40]
        SUB      r4,r4,r6
        ADD      r4,r4,r7,LSL #2
        ADD      r4,r4,#4
        LDRB     r1,[lr,r9]
        MOVS     r4,r4,ASR #3
        BEQ      |L1.260|
        
        
        ADD      r6,r1,#1
        
        CMP      r4,r6
        MOVGT    r4,r6
        RSB      r6,r6,#0
        CMP      r4,r6
        MOVLT    r4,r6
        ADD      r12,r12,r4
;        LDRB     r12,[lr,r12]
		usat	r12, #8, r12	
        SUB      r1,r5,r4
;        LDRB     r1,[lr,r1]
		usat	r1, #8, r1	
        STRB     r12,[r10,#0]
        
        STRB     r1,[r0,#0]
        B        |L1.260|
|L1.220|
        ADD      r5,r5,r6,LSL #1
        ADD      r5,r5,r4
        ADD      r12,r12,r4,LSL #1
        ADD      r12,r12,r6
        ADD      r5,r5,#2
        ADD      r12,r12,#2
        MOV      r5,r5,ASR #2
        MOV      r12,r12,ASR #2
        STRB     r5,[r0,#0]
        STRB     r12,[r10,#0]
|L1.260|
	    LDR	 	 r1,[sp,#-4]
	    ADD      r0,r0,r3
        ADD      r1,r1,#1
        CMP      r1,#8
        
        BLT      |L1.32|
        ADD      sp,sp,#0x14
        ;POP      {r4-r11,pc}
		ldmfd   r13!, {r4-r11, r15} ;  
        ENDP





        EXPORT Chroma_InPlaceDeblock


        END