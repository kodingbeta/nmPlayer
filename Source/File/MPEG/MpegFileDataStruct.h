	/************************************************************************
	*																		*
	*		VisualOn, Inc. Confidential and Proprietary, 2003-2008			*
	*																		*
	************************************************************************/
/*******************************************************************************
File:		MpegFileDataStruct.h

Contains:	Data Struct Of MPEG File

Written by:	East Zhou

Reference:	MPEG-2�˶�ͼ��ѹ��������ʱ�׼��MPEG���½�չ

Change History (most recent first):
2008-02-01		East			Create file

*******************************************************************************/

#ifndef __MPEG_File_Data_Struct
#define __MPEG_File_Data_Struct

#ifdef _VONAMESPACE
namespace _VONAMESPACE{
#endif

#define PACK_START_CODE             0xba
#define SYSTEM_HEADER_START_CODE    0xbb
#define PROGRAM_STREAM_MAP			0xbc		//10111100
#define PRIVATE_STREAM_1			0xbd		//10111101
#define PADDING_STREAM				0xbe		//10111110
#define PRIVATE_STREAM_2			0xbf		//10111111
#define ECM_STREAM					0xf0		//11110000

#define STREAM_TYPE_VIDEO_MPEG1     0x01
#define STREAM_TYPE_VIDEO_MPEG2     0x02
#define STREAM_TYPE_AUDIO_MPEG1     0x03
#define STREAM_TYPE_AUDIO_MPEG2     0x04
#define STREAM_TYPE_PRIVATE_SECTION 0x05
#define STREAM_TYPE_PRIVATE_DATA    0x06
#define STREAM_TYPE_AUDIO_AAC       0x0f
#define STREAM_TYPE_VIDEO_MPEG4     0x10
#define STREAM_TYPE_VIDEO_H264      0x1b
#define STREAM_TYPE_AUDIO_AC3_MIN_1	0x80
#define STREAM_TYPE_AUDIO_AC3_MAX_1	0x87
#define STREAM_TYPE_AUDIO_AC3_MIN_2	0xC0
#define STREAM_TYPE_AUDIO_AC3_MAX_2	0xCF
#define STREAM_TYPE_AUDIO_DTS_MIN_1	0x88
#define STREAM_TYPE_AUDIO_DTS_MAX_1	0x8F
#define STREAM_TYPE_AUDIO_DTS_MIN_2	0x98
#define STREAM_TYPE_AUDIO_DTS_MAX_2	0x9F
#define STREAM_TYPE_AUDIO_LPCM_MIN  0xA0
#define STREAM_TYPE_AUDIO_LPCM_MAX  0xAF

const VO_U32	MPEG_PES_HEADER						= 0x010000;
const VO_U32	MPEG_VIDEO_PICTURE_START_HEADER		= 0x00010000;
const VO_U32	MPEG_VIDEO_EXTENSION_START_HEADER	= 0xb5010000;
const VO_U32	MPEG_VIDEO_NALU_START_HEADER		= 0x01000000;
const VO_U64	MPEG_MAX_VALUE						= 0xFFFFFFFFFFFFFFFFLL;
const VO_U32	MPEG_MAX_BUFFER_TIME_LOCAL			= 5000;///<ms
const VO_U32	MPEG_MAX_BUFFER_TIME_STREAMING		= 500;///<ms
typedef enum
{
	UNKNOWN_CODE = 0,			//unknown
	PICTURE_START_CODE = 1,		//00
	SLICE_START_CODE = 2,		//01 - AF
	RESERVE_CODE = 3,			//B0, B1, B6
	USER_DATA_START_CODE = 4,	//B2
	SEQUENCE_HEADER_CODE = 5,	//B3
	SEQUENCE_ERROR_CODE = 6,	//B4
	EXTENSION_START_CODE = 7,	//B5
	SEQUENCE_END_CODE = 8,		//B7
	GROUP_START_CODE = 9,		//B8
	SYSTEM_CODE = 10,			//B9-FF
} CODE_TYPE;

typedef enum
{
	SEI_RBSP = 6,
	SPS_RBSP = 7,
	PPS_RBSP = 8,
	ACCESS_UNIT_DELIMITER_RBSP = 9,
	OTHER_RBSP
} AVC_CODE_TYPE;


const CODE_TYPE MPEG_CODES[] = 
{
	PICTURE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, //00-0F
	SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, //10-1F
	SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, //20-2F
	SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, //30-3F
	SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, //40-4F
	SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, //50-5F
	SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, //60-6F
	SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, //70-7F
	SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, //80-8F
	SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, //90-9F
	SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, SLICE_START_CODE, //A0-AF
	RESERVE_CODE, RESERVE_CODE, USER_DATA_START_CODE, SEQUENCE_HEADER_CODE, SEQUENCE_ERROR_CODE, EXTENSION_START_CODE, RESERVE_CODE, SEQUENCE_END_CODE, GROUP_START_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, //B0-BF
	SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, //C0-CF
	SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, //D0-DF
	SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, //E0-EF
	SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, SYSTEM_CODE, //F0-FF
};


typedef struct tagCodeInfo 
{
	CODE_TYPE		type;
	VO_U16			pos;	//pos in PES packet

	tagCodeInfo()
		: type(UNKNOWN_CODE)
		, pos(0)
	{
	}
} CodeInfo, *PCodeInfo;

const VO_U32 AdtsAACSample_rates[] =
{
	96000, 88200, 64000, 48000, 
	44100, 32000,24000, 22050, 
	16000, 12000, 11025, 8000,
	0, 0, 0, 0
};

#define DECLARE_USE_MP3_GLOBAL_VARIABLE\
	static const VO_U32	s_dwSamplingRates[4][3];\
	static const VO_U32	s_dwBitrates[2][3][15];

#define DEFINE_USE_MP3_GLOBAL_VARIABLE(cls)\
const VO_U32 cls::s_dwSamplingRates[4][3] = \
{\
	{11025, 12000, 8000,  },\
	{0,     0,     0,     },\
	{22050, 24000, 16000, },\
	{44100, 48000, 32000  }	\
};\
const VO_U32 cls::s_dwBitrates[2][3][15] = \
{\
	{\
		{0,32,64,96,128,160,192,224,256,288,320,352,384,416,448,},\
		{0,32,48,56, 64, 80, 96,112,128,160,192,224,256,320,384,},\
		{0,32,40,48, 56, 64, 80, 96,112,128,160,192,224,256,320,}\
	},\
	{\
		{0,32,48,56,64,80,96,112,128,144,160,176,192,224,256,},\
		{0,8,16,24,32,40,48,56,64,80,96,112,128,144,160,},\
		{0,8,16,24,32,40,48,56,64,80,96,112,128,144,160,}\
	}\
};

#define DECLARE_USE_MPEG_GLOBAL_VARIABLE\
	static const VO_U16	s_wFrameRate[16];

#define DEFINE_USE_MPEG_GLOBAL_VARIABLE(cls)\
	const VO_U16 cls::s_wFrameRate[16] = {0, 2398, 2400, 2500, 2997, 3000, 5000, 5994, 6000, 0, 0, 0, 0, 0, 0, 0};


typedef struct tagStreamInfo
{
	VO_U8 stream_type;
	VO_U8 stream_id;

	tagStreamInfo *next;
} StreamInfo;

const VO_U16 VO_AC3_SampleRate_Tab[3] = { 48000, 44100, 32000 };

const VO_U16 VO_AC3_FrameSize_Tab[38][3] = {
	{ 64,   69,   96   },
	{ 64,   70,   96   },
	{ 80,   87,   120  },
	{ 80,   88,   120  },
	{ 96,   104,  144  },
	{ 96,   105,  144  },
	{ 112,  121,  168  },
	{ 112,  122,  168  },
	{ 128,  139,  192  },
	{ 128,  140,  192  },
	{ 160,  174,  240  },
	{ 160,  175,  240  },
	{ 192,  208,  288  },
	{ 192,  209,  288  },
	{ 224,  243,  336  },
	{ 224,  244,  336  },
	{ 256,  278,  384  },
	{ 256,  279,  384  },
	{ 320,  348,  480  },
	{ 320,  349,  480  },
	{ 384,  417,  576  },
	{ 384,  418,  576  },
	{ 448,  487,  672  },
	{ 448,  488,  672  },
	{ 512,  557,  768  },
	{ 512,  558,  768  },
	{ 640,  696,  960  },
	{ 640,  697,  960  },
	{ 768,  835,  1152 },
	{ 768,  836,  1152 },
	{ 896,  975,  1344 },
	{ 896,  976,  1344 },
	{ 1024, 1114, 1536 },
	{ 1024, 1115, 1536 },
	{ 1152, 1253, 1728 },
	{ 1152, 1254, 1728 },
	{ 1280, 1393, 1920 },
	{ 1280, 1394, 1920 },
};

const VO_U8 VO_AC3_Channels_Tab[8] = {
	2, 1, 2, 3, 3, 4, 4, 5
};

const VO_U16 VO_DTS_SampleRate_Tab[16] = { 
	0, 8000, 16000, 32000, 0, 0, 11025, 22050, 44100, 0, 0, 12000, 24000, 48000, 0, 0 
};

const VO_U8 VO_DTS_Channels_Tab[16] = {
	1, 2, 2, 2, 2, 3, 3, 4, 4, 5, 6, 6, 6, 7, 8, 8
};

#define VOMAX(a,b) ((a) > (b) ? (a) : (b))

typedef enum
{
	VO_MPEG_STREAM_TYPE_AUDIO,
	VO_MPEG_STREAM_TYPE_VIDEO,
	VO_MPEG_STREAM_TYPE_UNKNOW
}VO_MPEG_STREAM_TYPE;

#ifdef _VONAMESPACE
}
#endif

#endif	//__MPEG_File_Data_Struct