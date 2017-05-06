/*************************************************************************

Copyright(c) 2003-2009 VisualOn SoftWare Co., Ltd.

Module Name:

decode.c

Abstract:

Subband Codec decode file.

Author:

Witten Wen 11-January-2010

Revision History:

*************************************************************************/
#ifndef __SBC_H
#define __SBC_H

#include "sbc_math.h"
#include "voSBCmemory.h"

#ifdef __cplusplus
extern "C" {
#endif

#define VOSBC_SYNCWORD	0x9C

/* channel mode */
#define VOSBR_CH_MONO		0x00
#define VOSBR_CH_DUAL_CHANNEL	0x01
#define VOSBR_CH_STEREO		0x02
#define VOSBR_CH_JOINT_STEREO	0x03

/* nrof_blocks */
#define NB4_VOSBC	0x00
#define NB8_VOSBC	0x01
#define NB12_VOSBC	0x02
#define NB16_VOSBC	0x03

/* sampling frequency, support 16KHz, 32KHz, 44.1KHz, 48KHz */
#define VOSBC_MODE_16	0x00
#define VOSBC_MODE_32	0x01
#define VOSBC_MODE_44 	0x02
#define VOSBC_MODE_48	0x03

/* allocation mode */
#define VOSBC_AM_LOUDNESS		0x00
#define VOSBC_AM_SNR		0x01


/* This structure contains an unpacked SBC frame.
Yes, there is probably quite some unused space herein */
struct sbc_frame 
{
		unsigned short    m_SampleRate;	
		unsigned char     m_Blocks;	
		unsigned char     channel_mode;
		unsigned char     m_Channels;		
		unsigned char     allocation_method;
		unsigned short    m_CodeSize;		
		unsigned char     m_Subbands;		
		unsigned char     m_Bitpool;		
		unsigned char     m_Length;
		unsigned char     m_Join;
		unsigned char     m_ScaleFactor[2][8];
		unsigned short    m_AudioSample[16][2][8];	
		int               m_SBSample[16][2][8];
		short             m_PCMSample[2][16*8];	
};

struct sbc_decoder_state 
{
		int m_Subbands;		
		int m_V[2][170];	
		int m_offset[2][16];
};

struct sbc_priv 
{
		int					m_Init;			
		struct sbc_frame	m_Frame;		
		struct sbc_decoder_state m_DecState;
};

struct sbc_struct 
{
		int m_Rate;		
		int m_Channels;	
		int m_Joint;	
		int m_Blocks;	
		int m_Subbands;	
		int m_Bitpool;	
		int m_Swap;		
		void *m_pPriv;	

		/* Witten added */
		VO_U8	*m_pInput;
		VO_U32	m_InSize;
		VO_U32	m_Consumed;
		VO_U32	m_FrameSize;

		VO_U8	*m_pFramBuf, *m_pNextBegin;
		VO_U32	m_TempLen;

		VO_MEM_OPERATOR *vopMemOP;

		//voCheck lib need
		VO_PTR				hCheck;
};

typedef struct sbc_struct sbc_t;

int SBCInit(sbc_t *psbc, unsigned long flags);		//sbc_init
	//int SBCReinit(sbc_t *psbc, unsigned long flags);	//sbc_reinit
int SBCDecode(sbc_t *psbc, 
			  VO_U8 *input, 
			  VO_U32 input_len, 
			  VO_U8 *output,
	          int output_len, 
			  VO_U32 *len
			  );

int SBCGetFrameLength(sbc_t *psbc);
int SBCGetFrameDuration(sbc_t *psbc);
int SBCGetCodesize(sbc_t *psbc);
unsigned char SBCCrc8(const unsigned char *data, VO_U32 len);
void SBCCalculateBits(const struct sbc_frame *, int (*)[8], unsigned char );
void SBCFinish(sbc_t *psbc);
VO_U32 voSBCSetInit(sbc_t *psbc);

#ifdef __cplusplus
}
#endif

#endif /* __SBC_H */ 