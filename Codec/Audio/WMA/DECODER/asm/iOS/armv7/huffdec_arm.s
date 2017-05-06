@//*@@@+++@@@@******************************************************************
@//
@// Microsoft Windows Media
@// Copyright (C) Microsoft Corporation. All rights reserved.
@//
@//*@@@---@@@@******************************************************************

@// Module Name:
@//
@//     huffdec_arm.s
@//
@// Abstract:
@// 
@//     ARM Arch-4 specific multiplications
@//
@//      Custom build with 
@//          armasm $(InputDir)\$(InputName).s -o=$(OutDir)\$(InputName).obj 
@//      and
@//          $(OutDir)\$(InputName).obj
@// 
@// Author:
@// 
@//     Sil Sanders (sils) October 9, 2001
@//
@// Revision History:
@//
@//     Jerry He (yamihe) Dec 4, 2003 
@//
@//*************************************************************************


@// For ARM, each loop below is 11 cycles long as compiled and could be reduced to 8.  
@// 3 cycles per double bit at 196 kbps = 3*88000 = 294000 and 16% of 206MHz is 33MHz.
@// So savings would be 0.9% speedup and was obsevered to be .7% to 1.1% and some small improvement for all profiles.
@//
@// However, unrolling these loops leads to even faster (if larger) code, with improvements at all bitrates from 0.5% to 1.7%.
@// there are 71 instructions in the unrolled code vs 25 in the loop.  


@	OPT         2       @ disable listing 
  #include "../../../inc/audio/v10/include/voWMADecID.h"
  .include    "kxarm.h"
  .include    "wma_member_arm.inc"
  .include	  "wma_arm_version.h"
@ OPT         1       @ enable listing
  
   
  @AREA    |.text|, CODE, READONLY
  .text .align 4
	
  .if WMA_OPT_HUFFDEC_ARM == 1
  
	.globl  _ibstrmPeekBits_Naked
	.globl	_ibstrmGetMoreData
	
	.globl	_huffDecGet
	.globl	_huffDecGet_i
	.globl	_huffDecGetMix
	.globl	_huffDecGetMIXVec
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ WMARESULT huffDecGet(const U16 *pDecodeTable, CWMAInputBitStream *bs, U32* puBitCnt, U32 *puResult, U32* puSign)
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

r3uBits         .req  r3
r4pNode         .req  r4
r5puResult      .req  r5
r6uBitCnt       .req  r6

rxx             .req  r6
.set O_puSign        , 0x10


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@  AREA    |.text|, CODE
_huffDecGet:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


@ 39   : {

    stmdb     sp!, {r4 - rxx, lr}  @ stmfd

    mov       r4pNode, r0
    mov       r6uBitCnt, r2
    mov       r5puResult, r3

@ 40   :      const int FIRST_LOAD = 10@
@ 41   :      const int SECOND_LOAD = 12@
@ 42   : 
@ 43   :      unsigned int ret_value@
@ 44   :      const unsigned short* node_base = pDecodeTable@
@ 45   : 
@ 46   :      U32 uBits@
@ 47   :      U32 codeword@
@ 48   :      int i = 0@
@ 49   : 
@ 50   :      WMARESULT  wmaResult@
@ 56   : 
@ 57   :      TRACEWMA_EXIT(wmaResult, ibstrmPeekBits(bs, FIRST_LOAD + SECOND_LOAD + 1, &uBits))@

    bl        _ibstrmPeekBits_Naked
    cmp       r0, #0
    bmi       exit

    @ first do the 8 2-bit tables
    mov       r2, #6                                @ mask offset bits used == 6

    and       r12, r2, r3uBits, lsr #29             @ i = 0, bits 31-30 into bits 2-1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #27             @ i = 1, bits 29-28 into bits 2-1 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 0 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #25             @ i = 2, bits 27-26 into bits 2-1 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 1 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #23             @ i = 3, bits 25-24 into bits 2-1 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 2 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #21             @ i = 4, bits 23-22 into bits 2-1 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 3 leaf note     
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #19             @ i = 5, bits 21-20 into bits 2-1 in case needed  
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 4 leaf note 
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #17             @ i = 6, bits 19-18 into bits 2-1 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 5 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #15             @ i = 7, bits 17-16 into bits 2-1 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 6 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    mov       r2, #2                                @ mask offset bits used == 2 for single bit tables
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 7 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    @ Now do the 6 single bit tables

    and       r12, r2, r3uBits, lsr #14             @ i = 8, bit 15 into bit 2 in case needed  

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #13             @ i = 9, bit 14 into bit 2 in case needed  
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 8 leaf note 
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #12             @ i = 10, bit 13 into bit 2 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 9 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #11             @ i = 11, bit 12 into bit 2 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 10 leaf note            
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #10             @ i = 12, bit 11 into bit 2 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 11 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #9              @ i = 13, bit 10 into bit 2 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 12 leaf note 
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    @@@ 
    tst       r1, #0x8000                 
    bne       decode_complete                    @ i = 13 leaf note            

@ 118  :      ASSERTWMA_EXIT( wmaResult, WMA_E_FAIL )@

    ldr       r0, WMAFAIL
    ldmia     sp!, {r4 - rxx, pc}  @ ldmfd

WMAFAIL:     .word       0x80004005

decode_complete:

@ 119  : 
@ 120  : decode_complete:
@ 122  :      *puBitCnt = ((ret_value >> 10) & (0x0000001F))@

    mov       lr, r1, lsr #10
    and       r2, lr, #0x1F
    mov       lr, #0xFF, 30                         @ 0x3FC
    str       r2, [r6uBitCnt]

@ 123  :      *puResult = ret_value & 0x000003FF@

    orr       r12, lr, #3                           @ 0x3FF
    and       r1, r1, r12

@ 124  :      if (*puResult >= 0x03FC)
@ 125  :          *puResult = *(node_base + (*puResult & 0x0003) + 1)@

    cmp       r1, lr                                @ 0x3FC
    bcc       L3018
    and       r1, r1, #3
    add       lr, r4pNode, r1, lsl #1
    ldrh      r1, [lr, #2]
    @@@
L3018:

    str       r1, [r5puResult]                      @ *puResult 

@ 127  :      if (puSign != NULL)
@ 128  :         *puSign = uBits << *puBitCnt@

    ldr       r1, [sp, #O_puSign]                       @ puSign
    mov       lr, r3uBits, lsl r2
    cmp       r1, #0
    strne     lr, [r1]                              @ *puSign = uBits << *puBitCnt
exit:

@ 130  : exit:
@ 134  :      return wmaResult@
@ 135  : }

    ldmia     sp!, {r4 - rxx, pc}  @ ldmfd
    @ENTRY_END huffDecGet
    
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ //WMARESULT huffDecGet(const U16 *pDecodeTable, CWMAInputBitStream *bs, U32* puBitCnt, U32 *puResult, U32* puSign)
@ WMARESULT huffDecGet_i(const U16 *pDecodeTable, CWMAInputBitStream *bs, U32 *puResult, U32* puSign)
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

r3uBits         .req  r3
r4pNode         .req   r4
r5puResult      .req   r5
r6puSign		.req   r6
r7bs			.req 	r7

rxx_i             .req   r11


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	.if LINUX_RVDS == 1
  	PRESERVE8
	.endif
	@AREA    |.text|, CODE
_huffDecGet_i:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


@ 39   : {

    stmdb     sp!, {r4 - rxx_i, lr}  @ stmfd
	
    mov			r4pNode, r0
    mov			r5puResult, r2
    mov			r6puSign, r3
    mov			r7bs, r1
    mov			r8, r2
		
@ 40   :      const int FIRST_LOAD = 10@
@ 41   :      const int SECOND_LOAD = 12@
@ 42   : 
@ 43   :      unsigned int ret_value@
@ 44   :      const unsigned short* node_base = pDecodeTable@
@ 45   : 
@ 46   :      U32 uBits@
@ 47   :      U32 codeword@
@ 48   :      int i = 0@
@ 49   : 
@ 50   :      WMARESULT  wmaResult@
@ 56   : 
@ 57   :      TRACEWMA_EXIT(wmaResult, ibstrmPeekBits(bs, FIRST_LOAD + SECOND_LOAD + 1, &uBits))@
   
    bl        _ibstrmPeekBits_Naked
    cmp       r0, #0
    bmi       exit_i
	
    @ first do the 8 2-bit tables
    mov       r2, #6                                @ mask offset bits used == 6

    and       r12, r2, r3uBits, lsr #29             @ i = 0, bits 31-30 into bits 2-1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #27             @ i = 1, bits 29-28 into bits 2-1 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 0 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #25             @ i = 2, bits 27-26 into bits 2-1 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 1 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #23             @ i = 3, bits 25-24 into bits 2-1 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 2 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #21             @ i = 4, bits 23-22 into bits 2-1 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 3 leaf note     
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #19             @ i = 5, bits 21-20 into bits 2-1 in case needed  
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 4 leaf note 
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #17             @ i = 6, bits 19-18 into bits 2-1 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 5 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #15             @ i = 7, bits 17-16 into bits 2-1 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 6 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    mov       r2, #2                                @ mask offset bits used == 2 for single bit tables
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 7 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    @ Now do the 6 single bit tables

    and       r12, r2, r3uBits, lsr #14             @ i = 8, bit 15 into bit 2 in case needed  

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #13             @ i = 9, bit 14 into bit 2 in case needed  
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 8 leaf note 
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #12             @ i = 10, bit 13 into bit 2 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 9 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #11             @ i = 11, bit 12 into bit 2 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 10 leaf note            
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #10             @ i = 12, bit 11 into bit 2 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 11 leaf note
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #9              @ i = 13, bit 10 into bit 2 in case needed
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 12 leaf note 
    add       r4pNode, r4pNode, r1, lsl #1

    ldrh      r1, [r4pNode, r12]! 
    @@@ 
    tst       r1, #0x8000                 
    bne       decode_complete_i                    @ i = 13 leaf note            

@ 118  :      ASSERTWMA_EXIT( wmaResult, WMA_E_FAIL )@

    ldr       r0, WMAFAIL_i
    ldmia     sp!, {r4 - rxx_i, pc}  @ ldmfd

WMAFAIL_i:     .word       0x80004005

decode_complete_i:

@ 119  : 
@ 120  : decode_complete:
@ 122  :      uBitCnt = ((ret_value >> 10) & (0x0000001F))@

    mov       lr, r1, lsr #10
    and       r2, lr, #0x1F
    mov       lr, #0xFF, 30                         @ 0x3FC

@ 123  :      *puResult = ret_value & 0x000003FF@

    orr       r12, lr, #3                           @ 0x3FF
    and       r1, r1, r12

@ 124  :      if (*puResult >= 0x03FC)
@ 125  :          *puResult = *(node_base + (*puResult & 0x0003) + 1)@

    cmp       r1, lr                                @ 0x3FC
    bcc       L3018_i
    and       r1, r1, #3
    add       lr, r4pNode, r1, lsl #1
    ldrh      r1, [lr, #2]
    @@@
L3018_i:

    str       r1, [r5puResult]                      @ *puResult 

@ 127  :      if (puSign != NULL)
@ 128  :         *puSign = uBits << uBitCnt@

    mov       lr, r3uBits, lsl r2
    cmp       r6puSign, #0
    strne     lr, [r6puSign]                              @ *puSign = uBits << *puBitCnt
    
@	if (bs->m_dwBitsLeft < uBitCnt)
@	{
@		LOAD_BITS_FROM_DotT@
@		LOAD_BITS_FROM_STREAM@
@
@		if (bs->m_dwBitsLeft < uBitCnt)
@		{
@			TRACEWMA_EXIT(wmaResult, ibstrmGetMoreData(bs, ModeGetFlush, uBitCnt))@
@		}
@	}
	ldr		r4, [r7bs, #CWMAInputBitStream_m_dwBitsLeft]
	cmp		r4, r2
	bcs		gFlushBits_huf
	
@ LOAD_BITS_FROM_DotT@

@ r2 = bs->m_dwDot
	ldr		r0, [r7bs, #CWMAInputBitStream_m_dwDot]
    
@ if (pibstrm->m_cBitDotT > 0)
	ldr		r3, [r7bs, #CWMAInputBitStream_m_cBitDotT]
	cmp		r3, #0
	bls		gFlushBitsPreLoadFromStream_i 
	
@ I32 cBitMoved = min (32 - pibstrm->m_dwBitsLeft, pibstrm->m_cBitDotT)@
	rsb		r12, r4, #32
	cmp		r12, r3
	movcs	r12, r3	
	
 @ pibstrm->m_cBitDotT -= cBitMoved@
	sub		r3, r3, r12
	ldr		lr, [r7bs, #CWMAInputBitStream_m_dwDotT]
	str		r3, [r7bs, #CWMAInputBitStream_m_cBitDotT]
	
@ pibstrm->m_dwBitsLeft += cBitMoved@
	add		r4, r4, r12
	mov		r5, lr, LSR r3				@pibstrm->m_dwDotT >> pibstrm->m_cBitDotT
	
@ pibstrm->m_dwDot <<= cBitMoved@
@ pibstrm->m_dwDot |= (pibstrm->m_dwDotT >> pibstrm->m_cBitDotT)@
	orr		r0, r5, r0, LSL r12
	
@ pibstrm->m_dwDotT &= ((I32) (1 << pibstrm->m_cBitDotT)) - 1@
	mov		r12, lr, LSR r3
	eor		lr, lr, r12, LSL r3
	str		lr, [r7bs, #CWMAInputBitStream_m_dwDotT]
	
gFlushBitsPreLoadFromStream_i:
	ldr		r3, [r7bs, #CWMAInputBitStream_m_cbBuflen]
	ldr		lr, [r7bs, #CWMAInputBitStream_m_pBuffer]

gFlushBitsLoadFromStream_i:
@ LOAD_BITS_FROM_STREAM@
@ while (pibstrm->m_dwBitsLeft <= 24 && pibstrm->m_cbBuflen > 0)
	cmp		r4, #24
	bhi		gFlushBitsGetMoreData_i

	cmp		r3, #0
	bls		gFlushBitsGetMoreData_i

@ --(pibstrm->m_cbBuflen)@
	sub		r3, r3, #1

@ pibstrm->m_dwBitsLeft += 8@
	ldrb	r12, [lr], #1
	add		r4, r4, #8

@ pibstrm->m_dwDot <<= 8@
@ pibstrm->m_dwDot |= *(pibstrm->m_pBuffer)++@
	orr		r0, r12, r0, LSL #8

	b		gFlushBitsLoadFromStream_i
	
gFlushBitsGetMoreData_i:
	str		lr, [r7bs, #CWMAInputBitStream_m_pBuffer]
	str		r3, [r7bs, #CWMAInputBitStream_m_cbBuflen]
	str		r0, [r7bs, #CWMAInputBitStream_m_dwDot]

@ if(pibstrm->m_dwBitsLeft < uBitCnt){
	cmp		r4, r2
	bcs		gFlushBits_huf
	
	str		r4, [r7bs, #CWMAInputBitStream_m_dwBitsLeft]
	
@ TRACEWMA_EXIT(wmaResult, ibstrmGetMoreData(bs, ModeGetFlush, uBitCnt))@
	mov		r0, r7bs
	mov		r1, #2
	bl		_ibstrmGetMoreData
	movs	r3, r0
	movmi	r0, r3
	bmi		exit_i
	
gFlushBits_huf:
@ pibstrm->m_dwBitsLeft -= dwNumBits@
	sub   r4, r4, r2 
	str   r4, [r7bs, #CWMAInputBitStream_m_dwBitsLeft]   

	mov   r0, #0
  
exit_i:

@ 130  : exit:
@ 134  :      return wmaResult@
@ 135  : }	
    ldmia     sp!, {r4 - rxx_i, pc}  @ ldmfd
    @ENTRY_END huffDecGet_i

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ WMARESULT huffDecGetMix(const U32 *pDecodeTable, CWMAInputBitStream *bs, huffResult *HResult, U32* puSign)
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
r3uBits         .req  r3
r4pNode         .req   r4
r5pHResult      .req   r5
r6puSign		.req   r6
r7bs			.req 	r7

rxx_M             .req   r7


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	.if LINUX_RVDS == 1
  	PRESERVE8
	.endif
	@AREA    |.text|, CODE
_huffDecGetMix:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


@ 39   : {

    stmdb     sp!, {r4 - rxx_M, lr}  @ stmfd
    
	mov		r4pNode, r0
	mov		r5pHResult, r2
	mov		r6puSign, r3
	mov		r7bs,	r1
@ 40   :      const int FIRST_LOAD = 10@
@ 41   :      const int SECOND_LOAD = 12@
@ 42   : 
@ 43   :      unsigned int ret_value@
@ 44   :      const unsigned short* node_base = pDecodeTable@
@ 45   : 
@ 46   :      U32 uBits@
@ 47   :      U32 codeword@
@ 48   :      int i = 0@
@ 49   : 
@ 50   :      WMARESULT  wmaResult@
@ 56   : 
@ 57   :      TRACEWMA_EXIT(wmaResult, ibstrmPeekBits(bs, FIRST_LOAD + SECOND_LOAD + 1, &uBits))@

    bl        _ibstrmPeekBits_Naked
    cmp       r0, #0
    bmi       exit_Mix

    @ first do the 8 2-bit tables
    mov       r2, #12                                @ mask offset bits used == 6

    and		r12, r2, r3uBits, lsr #28             @ i = 0, bits 31-30 into bits 2-1

    ldr		r1, [r4pNode, r12]! 
    and		r12, r2, r3uBits, lsr #26             @ i = 1, bits 29-28 into bits 2-1 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 0 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #24             @ i = 2, bits 27-26 into bits 2-1 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 1 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #22             @ i = 3, bits 25-24 into bits 2-1 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 2 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #20             @ i = 4, bits 23-22 into bits 2-1 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 3 leaf note     
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #18             @ i = 5, bits 21-20 into bits 2-1 in case needed  
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 4 leaf note 
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #16             @ i = 6, bits 19-18 into bits 2-1 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 5 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #14             @ i = 7, bits 17-16 into bits 2-1 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 6 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    mov       r2, #4                                @ mask offset bits used == 2 for single bit tables
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 7 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    @ Now do the 6 single bit tables

    and       r12, r2, r3uBits, lsr #13             @ i = 8, bit 15 into bit 2 in case needed  

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #12             @ i = 9, bit 14 into bit 2 in case needed  
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 8 leaf note 
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #11             @ i = 10, bit 13 into bit 2 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 9 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #10             @ i = 11, bit 12 into bit 2 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 10 leaf note            
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #9             @ i = 12, bit 11 into bit 2 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 11 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #8              @ i = 13, bit 10 into bit 2 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 12 leaf note 
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    @@@ 
    tst       r1, #0x80000000                 
    bne       decode_complete_Mix                    @ i = 13 leaf note            

@ 118  :      ASSERTWMA_EXIT( wmaResult, WMA_E_FAIL )@

    ldr       r0, WMAFAIL_Mix
    ldmia     sp!, {r4 - rxx_M, pc}  @ ldmfd

WMAFAIL_Mix:     .word       0x80004005

decode_complete_Mix:
@	ubitcount = (ret_value & (0x0000001F))@
@	if((HResult->state = ((ret_value>>23) & (0x3))) >= 2)
@	{
@		HResult->run = ((ret_value>>5) & (0x1ff))@
@		HResult->level = ((ret_value>>14) & (0x1ff))@
@	}     
@	if (puSign != NULL)
@		*puSign = uBits << ubitcount@
	and		r2, r1, #0x1F
@	strh	r2, [r5pHResult, #HuffResult_Ubitcount]
	mov		lr, r1, lsl #7
	mov		lr, lr, lsr #30
	str		lr, [r5pHResult, #HuffResult_state]
	cmp		lr, #2		
	blo		no_runlevel
	
	mov		r4, r1, lsl #18
	mov		lr, r1, lsl #9
	mov		r4, r4, lsr #23
	mov		lr, lr, lsr #23
	.if		ARMVERSION >= 6
	pkhbt	r4, r4, lr, lsl #16
	str		r4, [r5pHResult, #HuffResult_run]
	.else
	strh	r4, [r5pHResult, #HuffResult_run]
	strh	lr, [r5pHResult, #HuffResult_level]
	.endif
	
no_runlevel:	

@	if (puSign != NULL)
@		*puSign = uBits << ubitcount@
	cmp		r6puSign, #0
	movne	r1, r3uBits,lsl r2
	strne	r1, [r6puSign]	

@	if (bs->m_dwBitsLeft < ubitcount)
@	{
@		LOAD_BITS_FROM_DotT@
@		LOAD_BITS_FROM_STREAM@
@		if (bs->m_dwBitsLeft < ubitcount)
@		{
@			TRACEWMA_EXIT(wmaResult, ibstrmGetMoreData(bs, ModeGetFlush, ubitcount))@
@		}
@	}
	ldr		r4, [r7bs, #CWMAInputBitStream_m_dwBitsLeft]
	cmp		r4, r2
	bcs		gFlushBits_Mix
	
@ LOAD_BITS_FROM_DotT@

@ r2 = bs->m_dwDot
	ldr		r0, [r7bs, #CWMAInputBitStream_m_dwDot]
    
@ if (pibstrm->m_cBitDotT > 0)
	ldr		r3, [r7bs, #CWMAInputBitStream_m_cBitDotT]
	cmp		r3, #0
	bls		gFlushBitsPreLoadFromStream_Mix 
	
@ I32 cBitMoved = min (32 - pibstrm->m_dwBitsLeft, pibstrm->m_cBitDotT)@
	rsb		r12, r4, #32
	cmp		r12, r3
	movcs	r12, r3	
	
 @ pibstrm->m_cBitDotT -= cBitMoved@
	sub		r3, r3, r12
	ldr		lr, [r7bs, #CWMAInputBitStream_m_dwDotT]
	str		r3, [r7bs, #CWMAInputBitStream_m_cBitDotT]
	
@ pibstrm->m_dwBitsLeft += cBitMoved@
	add		r4, r4, r12
	mov		r5, lr, LSR r3				@pibstrm->m_dwDotT >> pibstrm->m_cBitDotT
	
@ pibstrm->m_dwDot <<= cBitMoved@
@ pibstrm->m_dwDot |= (pibstrm->m_dwDotT >> pibstrm->m_cBitDotT)@
	orr		r0, r5, r0, LSL r12
	
@ pibstrm->m_dwDotT &= ((I32) (1 << pibstrm->m_cBitDotT)) - 1@
	mov		r12, lr, LSR r3
	eor		lr, lr, r12, LSL r3
	str		lr, [r7bs, #CWMAInputBitStream_m_dwDotT]
	
gFlushBitsPreLoadFromStream_Mix:
	ldr		r3, [r7bs, #CWMAInputBitStream_m_cbBuflen]
	ldr		lr, [r7bs, #CWMAInputBitStream_m_pBuffer]

gFlushBitsLoadFromStream_Mix:
@ LOAD_BITS_FROM_STREAM@
@ while (pibstrm->m_dwBitsLeft <= 24 && pibstrm->m_cbBuflen > 0)
	cmp		r4, #24
	bhi		gFlushBitsGetMoreData_Mix

	cmp		r3, #0
	bls		gFlushBitsGetMoreData_Mix

@ --(pibstrm->m_cbBuflen)@
	sub		r3, r3, #1

@ pibstrm->m_dwBitsLeft += 8@
	ldrb	r12, [lr], #1
	add		r4, r4, #8

@ pibstrm->m_dwDot <<= 8@
@ pibstrm->m_dwDot |= *(pibstrm->m_pBuffer)++@
	orr		r0, r12, r0, LSL #8

	b		gFlushBitsLoadFromStream_Mix
	
gFlushBitsGetMoreData_Mix:
	str		lr, [r7bs, #CWMAInputBitStream_m_pBuffer]
	str		r3, [r7bs, #CWMAInputBitStream_m_cbBuflen]
	str		r0, [r7bs, #CWMAInputBitStream_m_dwDot]

@ if(pibstrm->m_dwBitsLeft < uBitCnt){
	cmp		r4, r2
	
	bcs		gFlushBits_Mix
	
	str   r4, [r7bs, #CWMAInputBitStream_m_dwBitsLeft]
	
@ TRACEWMA_EXIT(wmaResult, ibstrmGetMoreData(bs, ModeGetFlush, uBitCnt))@
	mov		r0, r7bs
	mov		r1, #2
	bl		_ibstrmGetMoreData
	movs	r3, r0
	movmi	r0, r3
	bmi		exit_Mix
	
gFlushBits_Mix:
@ pibstrm->m_dwBitsLeft -= dwNumBits@
	sub   r4, r4, r2 
	str   r4, [r7bs, #CWMAInputBitStream_m_dwBitsLeft]   
	mov   r0, #0	
	
exit_Mix:

@ 130  : exit:
@ 134  :      return wmaResult@
@ 135  : }

    ldmia     sp!, {r4 - rxx_M, pc}  @ ldmfd
    @ENTRY_END huffDecGetMix

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ WMARESULT WMARESULT huffDecGetMIXVec(const U32 *pDecodeTable, CWMAInputBitStream *bs, huffVecResult *HVResult)
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
r3uBits         .req  r3
r4pNode         .req  r4
r5pHVResult      .req  r5
r6bs			.req	r6
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	.if LINUX_RVDS == 1
  	PRESERVE8
	.endif
@	AREA    |.text|, CODE
_huffDecGetMIXVec:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


@ 39   : {

    stmdb     sp!, {r4 - r6, lr}  @ stmfd
    
	mov       r4pNode, r0
	mov       r5pHVResult, r2
	mov       r6bs, r1

@ 40   :      const int FIRST_LOAD = 10@
@ 41   :      const int SECOND_LOAD = 12@
@ 42   : 
@ 43   :      unsigned int ret_value@
@ 44   :      const unsigned short* node_base = pDecodeTable@
@ 45   : 
@ 46   :      U32 uBits@
@ 47   :      U32 codeword@
@ 48   :      int i = 0@
@ 49   : 
@ 50   :      WMARESULT  wmaResult@
@ 56   : 
@ 57   :      TRACEWMA_EXIT(wmaResult, ibstrmPeekBits(bs, FIRST_LOAD + SECOND_LOAD + 1, &uBits))@

    bl        _ibstrmPeekBits_Naked
    cmp       r0, #0
    bmi       exit_MixV

    @ first do the 8 2-bit tables
    mov       r2, #12                                @ mask offset bits used == 6

    and		r12, r2, r3uBits, lsr #28             @ i = 0, bits 31-30 into bits 2-1

    ldr		r1, [r4pNode, r12]! 
    and		r12, r2, r3uBits, lsr #26             @ i = 1, bits 29-28 into bits 2-1 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 0 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #24             @ i = 2, bits 27-26 into bits 2-1 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 1 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #22             @ i = 3, bits 25-24 into bits 2-1 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 2 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #20             @ i = 4, bits 23-22 into bits 2-1 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 3 leaf note     
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #18             @ i = 5, bits 21-20 into bits 2-1 in case needed  
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 4 leaf note 
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #16             @ i = 6, bits 19-18 into bits 2-1 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 5 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #14             @ i = 7, bits 17-16 into bits 2-1 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 6 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    mov       r2, #4                                @ mask offset bits used == 2 for single bit tables
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 7 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    @ Now do the 6 single bit tables

    and       r12, r2, r3uBits, lsr #13             @ i = 8, bit 15 into bit 2 in case needed  

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #12             @ i = 9, bit 14 into bit 2 in case needed  
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 8 leaf note 
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #11             @ i = 10, bit 13 into bit 2 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 9 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #10             @ i = 11, bit 12 into bit 2 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 10 leaf note            
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #9             @ i = 12, bit 11 into bit 2 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 11 leaf note
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    and       r12, r2, r3uBits, lsr #8              @ i = 13, bit 10 into bit 2 in case needed
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 12 leaf note 
    add       r4pNode, r4pNode, r1, lsl #2

    ldr		r1, [r4pNode, r12]! 
    @@@ 
    tst       r1, #0x80000000                 
    bne       decode_complete_MixV                    @ i = 13 leaf note            

@ 118  :      ASSERTWMA_EXIT( wmaResult, WMA_E_FAIL )@

    ldr       r0, WMAFAIL_MixV
    ldmia     sp!, {r4 - rxx, pc}  @ ldmfd

WMAFAIL_MixV:     .word       0x80004005

decode_complete_MixV:

@ 119  : 
@ 120  : decode_complete:    
@	uBitCnt = (ret_value & (0x0000001F))@
@	HVResult->state = ((ret_value>>21)&1)@
@	if(!(HVResult->state))
@		HVResult->iResult = ((ret_value>>5) & 0x0000FFFF)@
	and		r2, r1, #0x1F
@	strh	r2, [r5pHVResult, #HuffVecResult_uBitCnt]	
	ands	lr, r1, #1<<21
	mov		lr, lr, lsr #21
	strh	lr, [r5pHVResult, #HuffVecResult_state]
@	cmp		lr, #0	
	
	moveq	r4, r1, lsl #11
	moveq	r4, r4, lsr #16
	streqh	r4, [r5pHVResult, #HuffVecResult_iResult]

@	if (bs->m_dwBitsLeft < uBitCnt)
@	{
@		LOAD_BITS_FROM_DotT@
@		LOAD_BITS_FROM_STREAM@
@		if (bs->m_dwBitsLeft < ubitcount)
@		{
@			TRACEWMA_EXIT(wmaResult, ibstrmGetMoreData(bs, ModeGetFlush, uBitCnt))@
@		}
@	}
	ldr		r4, [r6bs, #CWMAInputBitStream_m_dwBitsLeft]
	cmp		r4, r2
	bcs		gFlushBits_MixV
	
@ LOAD_BITS_FROM_DotT@

@ r0 = bs->m_dwDot
	ldr		r0, [r7bs, #CWMAInputBitStream_m_dwDot]
    
@ if (pibstrm->m_cBitDotT > 0)
	ldr		r3, [r6bs, #CWMAInputBitStream_m_cBitDotT]
	cmp		r3, #0
	bls		gFlushBitsPreLoadFromStream_MixV 
	
@ I32 cBitMoved = min (32 - pibstrm->m_dwBitsLeft, pibstrm->m_cBitDotT)@
	rsb		r12, r4, #32
	cmp		r12, r3
	movcs	r12, r3	
	
 @ pibstrm->m_cBitDotT -= cBitMoved@
	sub		r3, r3, r12
	ldr		lr, [r6bs, #CWMAInputBitStream_m_dwDotT]
	str		r3, [r6bs, #CWMAInputBitStream_m_cBitDotT]
	
@ pibstrm->m_dwBitsLeft += cBitMoved@
	add		r4, r4, r12
	mov		r5, lr, LSR r3				@pibstrm->m_dwDotT >> pibstrm->m_cBitDotT
	
@ pibstrm->m_dwDot <<= cBitMoved@
@ pibstrm->m_dwDot |= (pibstrm->m_dwDotT >> pibstrm->m_cBitDotT)@
	orr		r0, r5, r0, LSL r12
	
@ pibstrm->m_dwDotT &= ((I32) (1 << pibstrm->m_cBitDotT)) - 1@
	mov		r12, lr, LSR r3
	eor		lr, lr, r12, LSL r3
	str		lr, [r6bs, #CWMAInputBitStream_m_dwDotT]
	
gFlushBitsPreLoadFromStream_MixV:
	ldr		r3, [r6bs, #CWMAInputBitStream_m_cbBuflen]
	ldr		lr, [r6bs, #CWMAInputBitStream_m_pBuffer]

gFlushBitsLoadFromStream_MixV:
@ LOAD_BITS_FROM_STREAM@
@ while (pibstrm->m_dwBitsLeft <= 24 && pibstrm->m_cbBuflen > 0)
	cmp		r4, #24
	bhi		gFlushBitsGetMoreData_MixV

	cmp		r3, #0
	bls		gFlushBitsGetMoreData_MixV

@ --(pibstrm->m_cbBuflen)@
	sub		r3, r3, #1

@ pibstrm->m_dwBitsLeft += 8@
	ldrb	r12, [lr], #1
	add		r4, r4, #8

@ pibstrm->m_dwDot <<= 8@
@ pibstrm->m_dwDot |= *(pibstrm->m_pBuffer)++@
	orr		r0, r12, r0, LSL #8

	b		gFlushBitsLoadFromStream_MixV
	
gFlushBitsGetMoreData_MixV:
	str		lr, [r6bs, #CWMAInputBitStream_m_pBuffer]
	str		r3, [r6bs, #CWMAInputBitStream_m_cbBuflen]
	str		r0, [r6bs, #CWMAInputBitStream_m_dwDot]

@ if(pibstrm->m_dwBitsLeft < uBitCnt){
	cmp		r4, r2	
	bcs		gFlushBits_MixV
  
	str		r4, [r6bs, #CWMAInputBitStream_m_dwBitsLeft]
	
@ TRACEWMA_EXIT(wmaResult, ibstrmGetMoreData(bs, ModeGetFlush, uBitCnt))@
	mov		r0, r6bs
	mov		r1, #2
	bl		_ibstrmGetMoreData
	movs	r3, r0
	movmi	r0, r3
	bmi		exit_MixV
	
gFlushBits_MixV:
@ pibstrm->m_dwBitsLeft -= uBitCnt@
	sub   r4, r4, r2 
	str   r4, [r6bs, #CWMAInputBitStream_m_dwBitsLeft]   
	mov   r0, #0

exit_MixV:

@ 130  : exit:
@ 134  :      return wmaResult@
@ 135  : }

    ldmia     sp!, {r4 - r6, pc}  @ ldmfd
    @ENTRY_END huffDecGetMIXVec
	
    .endif @ WMA_OPT_HUFFDEC_ARM
    
    
    
    