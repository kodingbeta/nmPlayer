@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
@
@  Copyright (c) 2010 The WebM project authors. All Rights Reserved.
@
@  Use of this source code is governed by a BSD-style license
@  that can be found in the LICENSE file in the root of the source
@  tree. An additional intellectual property rights grant can be found
@  in the file PATENTS.  All contributing project authors may
@  be found in the AUTHORS file in the root of the source tree.
@


    .global vp8_copy_mem8x4_neon 
	.type vp8_copy_mem8x4_neon, function
    @.arm
    @.eabi_attribute 24, 1 @Tag_ABI_align_needed
    @.eabi_attribute 25, 1 @Tag_ABI_align_preserved

.text
.p2align 2
@void copy_mem8x4_neon( unsigned char *src, int src_stride, unsigned char *dst, int dst_stride)
@-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
_vp8_copy_mem8x4_neon:
	vp8_copy_mem8x4_neon: @ PROC
    vld1.u8     {d0}, [r0], r1
    vld1.u8     {d1}, [r0], r1
    vst1.u8     {d0}, [r2], r3
    vld1.u8     {d2}, [r0], r1
    vst1.u8     {d1}, [r2], r3
    vld1.u8     {d3}, [r0], r1
    vst1.u8     {d2}, [r2], r3
    vst1.u8     {d3}, [r2], r3

    mov     pc, lr

	.size vp8_copy_mem8x4_neon, .-vp8_copy_mem8x4_neon    @ ENDP  @ |vp8_copy_mem8x4_neon|

	.section	.note.GNU-stack,"",%progbits
