/************************************************************************
*																		*
*		VisualOn, Inc. Confidential and Proprietary, 2010				*
*																		*
************************************************************************/

#include "voH264EncGlobal.h"

const VO_U8 coeff_token0[5] =
{
	0x11, // 0 <= nC < 2   1
	0x32, // 2<= nC < 4    11
	0xf4, // 4<= nC < 8  1111
    0x36, // 8<= nC         000011
    0x12  // nC == -1      01
};
const VO_U8 coeff_token_CDC[16] =
{
	0x76,/*000111 */0x11,/*1 */0x00,0x00,        
    0x46,/*000100 */0x66,/*000110 */0x13,/*001 */0x00,
    0x36,/*000011 */0x37,/*0000011 */0x27,/*0000010 */0x56,/*000101 */
    0x26,/*000010 */0x38,/*00000011 */0x28,/*00000010 */0x07,/*0000000 */
};
const VO_U8 coeff_token[3][64] =
{
	{
		0x55,/*0001 01*/	0x11,/*01*/0x00,0x00,
		0x77,/*0000 0111*/0x45,/*0001 00*/0x12,/*001*/0x00,
		0x78,/*0000 0011 1*/0x67,/*0000 0110*/0x56,/*0000 101*/0x34,/*00011*/
		0x79,/*0000 0001 11*/0x68,/*0000 0011 0*/0x57,/*0000 0101*/0x35,/*000011*/
		0x7a,/*0000 0000 111*/0x69,/*0000 0001 10 */0x58,/*0000 0010 1 */0x46,/*0000100 */
		0xfc,/*0000 0000 0111 1 */0x6a,/*0000 0000 110 */0x59,/*0000 0001 01 */0x47,/*00000100 */
		0xbc,/*0000 0000 0101 1 */0xec,/*0000 0000 0111 0 */0x5a,/*0000 0000 101 */0x48,/*000000100 */
		0x8c,/*0000 0000 0100 0 */0xac,/*0000 0000 0101 0 */0xdc,/*0000 0000 0110 1 */0x49,/*0000 0001 00 */
		0xfd,/*0000 0000 0011 11 */0xed,/*0000 0000 0011 10 */0x9c,/*0000 0000 0100 1 */0x4a,/*0000 0000 100 */
		0xbd,/*0000 0000 0010 11 */0xad,/*0000 0000 0010 10 */0xdd,/*0000 0000 0011 01 */0xcc,/*0000 0000 0110 0 */
		0xfe,/*0000 0000 0001 111 */0xee,/*0000 0000 0001 110 */0x9d,/*0000 0000 0010 01 */0xcd,/*0000 0000 0011 00 */
		0xbe,/*0000 0000 0001 011 */0xae,/*0000 0000 0001 010 */ 0xde,/*0000 0000 0001 101 */0x8d,/*0000 0000 0010 00 */
		0xff,/*0000 0000 0000 1111 */0x1e,/*0000 0000 0000 001 */0x9e,/*0000 0000 0001 001 */0xce,/*0000 0000 0001 100 */
		0xbf,/*0000 0000 0000 1011 */0xef,/*0000 0000 0000 1110 */0xdf,/*0000 0000 0000 1101 */0x8e,/*0000 0000 0001 000 */
		0x7f,/*0000 0000 0000 0111 */0xaf,/*0000 0000 0000 1010 */0x9f,/*0000 0000 0000 1001 */0xcf,/*0000000000001100 */
		0x4f,/*0000 0000 0000 0100 */0x6f,/*0000 0000 0000 0110 */0x5f,/*0000 0000 0000 0101 */0x8f,/*0000000000001000 */
	},
	{
        0xb6,/*001011 */0x22,/*10 */0x00,/* */0x00,/* */
        0x76,/*000111 */0x75,/*00111 */0x33,/*011 */0x00,/* */
        0x77,/*0000111 */0xa6,/*001010 */0x96,/*001001 */0x54,/*0101 */
        0x78,/*00000111 */0x66,/*000110 */0x56,/*000101 */0x44,/*0100 */
        0x48,/*00000100 */0x67,/*0000110 */0x57,/*0000101 */0x65,/*00110 */
        0x79,/*000000111 */0x68,/*00000110 */0x58,/*00000101 */0x86,/*001000 */
        0xfb,/*00000001111 */0x69,/*000000110 */0x59,/*000000101 */0x46,/*000100 */
        0xbb,/*00000001011 */0xeb,/*00000001110 */0xdb,/*00000001101 */0x47,/*0000100 */
        0xfc,/*000000001111 */0xab,/*00000001010 */0x9b,/*00000001001 */0x49,/*000000100 */
        0xbc,/*000000001011 */0xec,/*000000001110 */0xdc,/*000000001101 */0xcb,/*00000001100 */
        0x8c,/*000000001000 */0xac,/*000000001010 */0x9c,/*000000001001 */0x8b,/*00000001000 */
        0xfd,/*0000000001111 */0xed,/*0000000001110 */0xdd,/*0000000001101 */0xcc,/*000000001100 */
        0xbd,/*0000000001011 */0xad,/*0000000001010 */0x9d,/*0000000001001 */0xcd,/*0000000001100 */
        0x7d,/*0000000000111 */0xbe,/*00000000001011 */0x6d,/*0000000000110 */0x8d,/*0000000001000 */
        0x9e,/*00000000001001 */0x8e,/*00000000001000 */0xae,/*00000000001010 */0x1d,/*0000000000001 */
        0x7e,/*00000000000111 */0x6e,/*00000000000110 */0x5e,/*00000000000101 */0x4e,/*00000000000100 */
    },
    
	{
		0xf6,/*001111 */0xe4,/*1110 */0x00,0x00,
		0xb6,/*001011 */0xf5,/*01111 */0xd4,/*1101 */0x00,
		0x86,/*001000 */0xc5,/*01100 */0xe5,/*01110 */0xc4,/*1100 */
		0xf7,/*0001111 */0xa5,/*01010 */0xb5,/*01011 */0xb4,/*1011 */
		0xb7,/*0001011 */0x85,/*01000 */0x95,/*01001 */0xa4,/*1010 */
		0x97,/*0001001 */0xe6,/*001110 */0xd6,/*001101 */0x94,/*1001 */
		0x87,/*0001000 */0xa6,/*001010 */0x96,/*001001 */0x84,/*1000 */
		0xf8,/*00001111 */0xe7,/*0001110 */0xd7,/*0001101 */0xd5,/*01101 */
		0xb8,/*00001011 */0xe8,/*00001110 */0xa7,/*0001010 */0xc6,/*001100 */
		0xf9,/*000001111 */0xa8,/*00001010 */0xd8,/*00001101 */0xc7,/*0001100 */
		0xb9,/*000001011 */0xe9,/*000001110 */0x98,/*00001001 */0xc8,/*00001100 */
		0x89,/*000001000 */0xa9,/*000001010 */0xd9,/*000001101 */0x88,/*00001000 */
		0xda,/*0000001101 */0x79,/*000000111 */0x99,/*000001001 */0xc9,/*000001100 */
		0x9a,/*0000001001 */0xca,/*0000001100 */0xba,/*0000001011 */0xaa,/*0000001010 */
		0x5a,/*0000000101 */0x8a,/*0000001000 */0x7a,/*0000000111 */0x6a,/*0000000110 */
		0x1a,/*0000000001 */0x4a,/*0000000100 */0x3a,/*0000000011 */0x2a,/*0000000010 */
	}
};
const LEVEL_TYPE level_table[7][LEVEL_SIZE] =
{
	//suffix 0
	{
		{4193,28,2},{4191,28,2},{4189,28,2},{4187,28,2},
		{4185,28,2},{4183,28,2},{4181,28,2},{4179,28,2},
		{4177,28,2},{4175,28,2},{4173,28,2},{4171,28,2},
		{4169,28,2},{4167,28,2},{4165,28,2},{4163,28,2},
		{4161,28,2},{4159,28,2},{4157,28,2},{4155,28,2},
		{4153,28,2},{4151,28,2},{4149,28,2},{4147,28,2},
		{4145,28,2},{4143,28,2},{4141,28,2},{4139,28,2},
		{4137,28,2},{4135,28,2},{4133,28,2},{4131,28,2},
		{4129,28,2},{4127,28,2},{4125,28,2},{4123,28,2},
		{4121,28,2},{4119,28,2},{4117,28,2},{4115,28,2},
		{4113,28,2},{4111,28,2},{4109,28,2},{4107,28,2},
		{4105,28,2},{4103,28,2},{4101,28,2},{4099,28,2},
		{4097,28,2},{31,19,2},{29,19,2},{27,19,2},
		{25,19,2},{23,19,2},{21,19,2},{19,19,2},
		{17,19,2},{1,14,2},{1,12,2},{1,10,2},
		{1,8,2},{1,6,1},{1,4,1},{1,2,1},
		{1,255,1},{1,1,1},{1,3,1},{1,5,1},
		{1,7,2},{1,9,2},{1,11,2},{1,13,2},
		{16,19,2},{18,19,2},{20,19,2},{22,19,2},
		{24,19,2},{26,19,2},{28,19,2},{30,19,2},
		{4096,28,2},{4098,28,2},{4100,28,2},{4102,28,2},
		{4104,28,2},{4106,28,2},{4108,28,2},{4110,28,2},
		{4112,28,2},{4114,28,2},{4116,28,2},{4118,28,2},
		{4120,28,2},{4122,28,2},{4124,28,2},{4126,28,2},
		{4128,28,2},{4130,28,2},{4132,28,2},{4134,28,2},
		{4136,28,2},{4138,28,2},{4140,28,2},{4142,28,2},
		{4144,28,2},{4146,28,2},{4148,28,2},{4150,28,2},
		{4152,28,2},{4154,28,2},{4156,28,2},{4158,28,2},
		{4160,28,2},{4162,28,2},{4164,28,2},{4166,28,2},
		{4168,28,2},{4170,28,2},{4172,28,2},{4174,28,2},
		{4176,28,2},{4178,28,2},{4180,28,2},{4182,28,2},
		{4184,28,2},{4186,28,2},{4188,28,2},{4190,28,2}
	},
	//suffix 1
	{
		{4193,28,2},{4191,28,2},{4189,28,2},{4187,28,2},
		{4185,28,2},{4183,28,2},{4181,28,2},{4179,28,2},
		{4177,28,2},{4175,28,2},{4173,28,2},{4171,28,2},
		{4169,28,2},{4167,28,2},{4165,28,2},{4163,28,2},
		{4161,28,2},{4159,28,2},{4157,28,2},{4155,28,2},
		{4153,28,2},{4151,28,2},{4149,28,2},{4147,28,2},
		{4145,28,2},{4143,28,2},{4141,28,2},{4139,28,2},
		{4137,28,2},{4135,28,2},{4133,28,2},{4131,28,2},
		{4129,28,2},{4127,28,2},{4125,28,2},{4123,28,2},
		{4121,28,2},{4119,28,2},{4117,28,2},{4115,28,2},
		{4113,28,2},{4111,28,2},{4109,28,2},{4107,28,2},
		{4105,28,2},{4103,28,2},{4101,28,2},{4099,28,2},
		{4097,28,2},{3,16,2},{3,15,2},{3,14,2},
		{3,13,2},{3,12,2},{3,11,2},{3,10,2},
		{3,9,2},{3,8,2},{3,7,2},{3,6,2},
		{3,5,2},{3,4,1},{3,3,1},{3,2,1},
		{2,1,1},{2,2,1},{2,3,1},{2,4,1},
		{2,5,2},{2,6,2},{2,7,2},{2,8,2},
		{2,9,2},{2,10,2},{2,11,2},{2,12,2},
		{2,13,2},{2,14,2},{2,15,2},{2,16,2},
		{4096,28,2},{4098,28,2},{4100,28,2},{4102,28,2},
		{4104,28,2},{4106,28,2},{4108,28,2},{4110,28,2},
		{4112,28,2},{4114,28,2},{4116,28,2},{4118,28,2},
		{4120,28,2},{4122,28,2},{4124,28,2},{4126,28,2},
		{4128,28,2},{4130,28,2},{4132,28,2},{4134,28,2},
		{4136,28,2},{4138,28,2},{4140,28,2},{4142,28,2},
		{4144,28,2},{4146,28,2},{4148,28,2},{4150,28,2},
		{4152,28,2},{4154,28,2},{4156,28,2},{4158,28,2},
		{4160,28,2},{4162,28,2},{4164,28,2},{4166,28,2},
		{4168,28,2},{4170,28,2},{4172,28,2},{4174,28,2},
		{4176,28,2},{4178,28,2},{4180,28,2},{4182,28,2},
		{4184,28,2},{4186,28,2},{4188,28,2},{4190,28,2}
	},
	//suffix 2
	{
		{4163,28,3},{4161,28,3},{4159,28,3},{4157,28,3},
		{4155,28,3},{4153,28,3},{4151,28,3},{4149,28,3},
		{4147,28,3},{4145,28,3},{4143,28,3},{4141,28,3},
		{4139,28,3},{4137,28,3},{4135,28,3},{4133,28,3},
		{4131,28,3},{4129,28,3},{4127,28,3},{4125,28,3},
		{4123,28,3},{4121,28,3},{4119,28,3},{4117,28,3},
		{4115,28,3},{4113,28,3},{4111,28,3},{4109,28,3},
		{4107,28,3},{4105,28,3},{4103,28,3},{4101,28,3},
		{4099,28,3},{4097,28,3},{7,17,3},{5,17,3},
		{7,16,3},{5,16,3},{7,15,3},{5,15,3},
		{7,14,3},{5,14,3},{7,13,3},{5,13,3},
		{7,12,3},{5,12,3},{7,11,3},{5,11,3},
		{7,10,3},{5,10,3},{7,9,3},{5,9,3},
		{7,8,3},{5,8,3},{7,7,3},{5,7,3},
		{7,6,3},{5,6,3},{7,5,2},{5,5,2},
		{7,4,2},{5,4,2},{7,3,2},{5,3,2},
		{6,2,2},{4,3,2},{6,3,2},{4,4,2},
		{6,4,2},{4,5,2},{6,5,2},{4,6,3},
		{6,6,3},{4,7,3},{6,7,3},{4,8,3},
		{6,8,3},{4,9,3},{6,9,3},{4,10,3},
		{6,10,3},{4,11,3},{6,11,3},{4,12,3},
		{6,12,3},{4,13,3},{6,13,3},{4,14,3},
		{6,14,3},{4,15,3},{6,15,3},{4,16,3},
		{6,16,3},{4,17,3},{6,17,3},{4096,28,3},
		{4098,28,3},{4100,28,3},{4102,28,3},{4104,28,3},
		{4106,28,3},{4108,28,3},{4110,28,3},{4112,28,3},
		{4114,28,3},{4116,28,3},{4118,28,3},{4120,28,3},
		{4122,28,3},{4124,28,3},{4126,28,3},{4128,28,3},
		{4130,28,3},{4132,28,3},{4134,28,3},{4136,28,3},
		{4138,28,3},{4140,28,3},{4142,28,3},{4144,28,3},
		{4146,28,3},{4148,28,3},{4150,28,3},{4152,28,3},
		{4154,28,3},{4156,28,3},{4158,28,3},{4160,28,3}
	},
	//suffix 3
	{
		{4103,28,4},{4101,28,4},{4099,28,4},{4097,28,4},
		{15,18,4},{13,18,4},{11,18,4},{9,18,4},
		{15,17,4},{13,17,4},{11,17,4},{9,17,4},
		{15,16,4},{13,16,4},{11,16,4},{9,16,4},
		{15,15,4},{13,15,4},{11,15,4},{9,15,4},
		{15,14,4},{13,14,4},{11,14,4},{9,14,4},
		{15,13,4},{13,13,4},{11,13,4},{9,13,4},
		{15,12,4},{13,12,4},{11,12,4},{9,12,4},
		{15,11,4},{13,11,4},{11,11,4},{9,11,4},
		{15,10,4},{13,10,4},{11,10,4},{9,10,4},
		{15,9,4},{13,9,4},{11,9,4},{9,9,4},
		{15,8,4},{13,8,4},{11,8,4},{9,8,4},
		{15,7,4},{13,7,4},{11,7,4},{9,7,4},
		{15,6,3},{13,6,3},{11,6,3},{9,6,3},
		{15,5,3},{13,5,3},{11,5,3},{9,5,3},
		{15,4,3},{13,4,3},{11,4,3},{9,4,3},
		{14,3,3},{8,4,3},{10,4,3},{12,4,3},
		{14,4,3},{8,5,3},{10,5,3},{12,5,3},
		{14,5,3},{8,6,3},{10,6,3},{12,6,3},
		{14,6,3},{8,7,4},{10,7,4},{12,7,4},
		{14,7,4},{8,8,4},{10,8,4},{12,8,4},
		{14,8,4},{8,9,4},{10,9,4},{12,9,4},
		{14,9,4},{8,10,4},{10,10,4},{12,10,4},
		{14,10,4},{8,11,4},{10,11,4},{12,11,4},
		{14,11,4},{8,12,4},{10,12,4},{12,12,4},
		{14,12,4},{8,13,4},{10,13,4},{12,13,4},
		{14,13,4},{8,14,4},{10,14,4},{12,14,4},
		{14,14,4},{8,15,4},{10,15,4},{12,15,4},
		{14,15,4},{8,16,4},{10,16,4},{12,16,4},
		{14,16,4},{8,17,4},{10,17,4},{12,17,4},
		{14,17,4},{8,18,4},{10,18,4},{12,18,4},
		{14,18,4},{4096,28,4},{4098,28,4},{4100,28,4}
	},
	//suffix 4
	{
		{31,12,5},{29,12,5},{27,12,5},{25,12,5},
		{23,12,5},{21,12,5},{19,12,5},{17,12,5},
		{31,11,5},{29,11,5},{27,11,5},{25,11,5},
		{23,11,5},{21,11,5},{19,11,5},{17,11,5},
		{31,10,5},{29,10,5},{27,10,5},{25,10,5},
		{23,10,5},{21,10,5},{19,10,5},{17,10,5},
		{31,9,5},{29,9,5},{27,9,5},{25,9,5},
		{23,9,5},{21,9,5},{19,9,5},{17,9,5},
		{31,8,5},{29,8,5},{27,8,5},{25,8,5},
		{23,8,5},{21,8,5},{19,8,5},{17,8,5},
		{31,7,4},{29,7,4},{27,7,4},{25,7,4},
		{23,7,4},{21,7,4},{19,7,4},{17,7,4},
		{31,6,4},{29,6,4},{27,6,4},{25,6,4},
		{23,6,4},{21,6,4},{19,6,4},{17,6,4},
		{31,5,4},{29,5,4},{27,5,4},{25,5,4},
		{23,5,4},{21,5,4},{19,5,4},{17,5,4},
		{30,4,4},{16,5,4},{18,5,4},{20,5,4},
		{22,5,4},{24,5,4},{26,5,4},{28,5,4},
		{30,5,4},{16,6,4},{18,6,4},{20,6,4},
		{22,6,4},{24,6,4},{26,6,4},{28,6,4},
		{30,6,4},{16,7,4},{18,7,4},{20,7,4},
		{22,7,4},{24,7,4},{26,7,4},{28,7,4},
		{30,7,4},{16,8,5},{18,8,5},{20,8,5},
		{22,8,5},{24,8,5},{26,8,5},{28,8,5},
		{30,8,5},{16,9,5},{18,9,5},{20,9,5},
		{22,9,5},{24,9,5},{26,9,5},{28,9,5},
		{30,9,5},{16,10,5},{18,10,5},{20,10,5},
		{22,10,5},{24,10,5},{26,10,5},{28,10,5},
		{30,10,5},{16,11,5},{18,11,5},{20,11,5},
		{22,11,5},{24,11,5},{26,11,5},{28,11,5},
		{30,11,5},{16,12,5},{18,12,5},{20,12,5},
		{22,12,5},{24,12,5},{26,12,5},{28,12,5}
	},
	//suffix 5
	{
		{63,9,6},{61,9,6},{59,9,6},{57,9,6},
		{55,9,6},{53,9,6},{51,9,6},{49,9,6},
		{47,9,6},{45,9,6},{43,9,6},{41,9,6},
		{39,9,6},{37,9,6},{35,9,6},{33,9,6},
		{63,8,5},{61,8,5},{59,8,5},{57,8,5},
		{55,8,5},{53,8,5},{51,8,5},{49,8,5},
		{47,8,5},{45,8,5},{43,8,5},{41,8,5},
		{39,8,5},{37,8,5},{35,8,5},{33,8,5},
		{63,7,5},{61,7,5},{59,7,5},{57,7,5},
		{55,7,5},{53,7,5},{51,7,5},{49,7,5},
		{47,7,5},{45,7,5},{43,7,5},{41,7,5},
		{39,7,5},{37,7,5},{35,7,5},{33,7,5},
		{63,6,5},{61,6,5},{59,6,5},{57,6,5},
		{55,6,5},{53,6,5},{51,6,5},{49,6,5},
		{47,6,5},{45,6,5},{43,6,5},{41,6,5},
		{39,6,5},{37,6,5},{35,6,5},{33,6,5},
		{62,5,5},{32,6,5},{34,6,5},{36,6,5},
		{38,6,5},{40,6,5},{42,6,5},{44,6,5},
		{46,6,5},{48,6,5},{50,6,5},{52,6,5},
		{54,6,5},{56,6,5},{58,6,5},{60,6,5},
		{62,6,5},{32,7,5},{34,7,5},{36,7,5},
		{38,7,5},{40,7,5},{42,7,5},{44,7,5},
		{46,7,5},{48,7,5},{50,7,5},{52,7,5},
		{54,7,5},{56,7,5},{58,7,5},{60,7,5},
		{62,7,5},{32,8,5},{34,8,5},{36,8,5},
		{38,8,5},{40,8,5},{42,8,5},{44,8,5},
		{46,8,5},{48,8,5},{50,8,5},{52,8,5},
		{54,8,5},{56,8,5},{58,8,5},{60,8,5},
		{62,8,5},{32,9,6},{34,9,6},{36,9,6},
		{38,9,6},{40,9,6},{42,9,6},{44,9,6},
		{46,9,6},{48,9,6},{50,9,6},{52,9,6},
		{54,9,6},{56,9,6},{58,9,6},{60,9,6}
	},
	//suffix 6
	{
		{127,8,6},{125,8,6},{123,8,6},{121,8,6},
		{119,8,6},{117,8,6},{115,8,6},{113,8,6},
		{111,8,6},{109,8,6},{107,8,6},{105,8,6},
		{103,8,6},{101,8,6},{99,8,6},{97,8,6},
		{95,8,6},{93,8,6},{91,8,6},{89,8,6},
		{87,8,6},{85,8,6},{83,8,6},{81,8,6},
		{79,8,6},{77,8,6},{75,8,6},{73,8,6},
		{71,8,6},{69,8,6},{67,8,6},{65,8,6},
		{127,7,6},{125,7,6},{123,7,6},{121,7,6},
		{119,7,6},{117,7,6},{115,7,6},{113,7,6},
		{111,7,6},{109,7,6},{107,7,6},{105,7,6},
		{103,7,6},{101,7,6},{99,7,6},{97,7,6},
		{95,7,6},{93,7,6},{91,7,6},{89,7,6},
		{87,7,6},{85,7,6},{83,7,6},{81,7,6},
		{79,7,6},{77,7,6},{75,7,6},{73,7,6},
		{71,7,6},{69,7,6},{67,7,6},{65,7,6},
		{126,6,6},{64,7,6},{66,7,6},{68,7,6},
		{70,7,6},{72,7,6},{74,7,6},{76,7,6},
		{78,7,6},{80,7,6},{82,7,6},{84,7,6},
		{86,7,6},{88,7,6},{90,7,6},{92,7,6},
		{94,7,6},{96,7,6},{98,7,6},{100,7,6},
		{102,7,6},{104,7,6},{106,7,6},{108,7,6},
		{110,7,6},{112,7,6},{114,7,6},{116,7,6},
		{118,7,6},{120,7,6},{122,7,6},{124,7,6},
		{126,7,6},{64,8,6},{66,8,6},{68,8,6},
		{70,8,6},{72,8,6},{74,8,6},{76,8,6},
		{78,8,6},{80,8,6},{82,8,6},{84,8,6},
		{86,8,6},{88,8,6},{90,8,6},{92,8,6},
		{94,8,6},{96,8,6},{98,8,6},{100,8,6},
		{102,8,6},{104,8,6},{106,8,6},{108,8,6},
		{110,8,6},{112,8,6},{114,8,6},{116,8,6},
		{118,8,6},{120,8,6},{122,8,6},{124,8,6}
	}
};

/* [i_total_coeff-1][i_total_zeros] */
const VO_U8 total_zeros[15][16] =
{
    { // 1 
        0x11,/*1*/0x33,/*011*/0x23,/*010*/0x34,/*0011*/
        0x24,/*0010*/0x35,/*00011*/0x25,/*00010*/0x36,/*000011*/
        0x26,/*000010*/0x37,/*0000011*/0x27,/*0000010*/0x38,/*00000011*/
        0x28,/*00000010*/0x39,/*000000011*/0x29,/*000000010*/0x19/*000000001*/
    },
    { // 2 
        0x73,/*111*/0x63,/*110*/0x53,/*101*/0x43,/*100*/
        0x33,/*011*/0x54,/*0101*/0x44,/*0100*/0x34,/*0011*/
        0x24,/*0010*/0x35,/*00011*/0x25,/*00010*/0x36,/*000011*/
        0x26,/*000010*/0x16,/*000001*/0x06/*000000*/
    },
    { // 3 
        0x54,/*0101*/0x73,/*111*/0x63,/*110*/0x53,/*101*/
        0x44,/*0100*/0x34,/*0011*/0x43,/*100*/0x33,/*011*/
        0x24,/*0010*/0x35,/*00011*/0x25,/*00010*/0x16,/*000001*/
        0x15,/*00001*/0x06/*000000*/
    },
    { // 4 
        0x35,/*00011*/0x73,/*111*/0x54,/*0101*/0x44,/*0100*/
        0x63,/*110*/0x53,/*101*/0x43,/*100*/0x34,/*0011*/
        0x33,/*011*/0x24,/*0010*/0x25,/*00010*/0x15,/*00001*/
        0x05/*00000*/
    },
    { // 5 
        0x54,/*0101*/0x44,/*0100*/0x34,/*0011*/0x73,/*111*/
        0x63,/*110*/0x53,/*101*/0x43,/*100*/0x33,/*011*/
        0x24,/*0010*/0x15,/*00001*/0x14,/*0001*/0x05/*00000*/
    },
    { // 6 
        0x16,/*000001*/0x15,/*00001*/0x73,/*111*/0x63,/*110*/
        0x53,/*101*/0x43,/*100*/0x33,/*011*/0x23,/*010*/
        0x14,/*0001*/0x13,/*001*/0x06/*000000*/
    },
    { // 7 
        0x16,/*000001*/0x15,/*00001*/0x53,/*101*/0x43,/*100*/
        0x33,/*011*/0x32,/*11*/0x23,/*010*/0x14,/*0001*/
        0x13,/*001*/0x06/*000000*/
    },
    { // 8 
        0x16,/*000001*/0x14,/*0001*/0x15,/*00001*/0x33,/*011*/
        0x32,/*11*/0x22,/*10*/0x23,/*010*/0x13,/*001*/
        0x06/*000000*/
    },
    {0x16,/*000001*/0x06,/*000000*/0x14,/*0001*/0x32,/*11*/0x22,/*10*/0x13,/*001*/0x12,/*01*/0x15/*00001*/},// 9 
    {0x15,/*00001*/0x05,/*00000*/0x13,/*001*/0x32,/*11*/0x22,/*10*/0x12,/*01*/0x14/*0001*/},// 10
    {0x04,/*0000*/0x14,/*0001*/0x13,/*001*/0x23,/*010*/0x11,/*1*/0x33/*011*/},// 11 
    {0x04,/*0000*/0x14,/*0001*/0x12,/*01*/0x11,/*1*/0x13/*001*/},// 12
    {0x03,/*000*/0x13,/*001*/0x11,/*1*/0x12/*01*/},// 13
    {0x02,/*00*/0x12,/*01*/0x11/*1*/},// 14
    {0x01,/*0*/0x11,/*1*/},// 15
};

/* [i_total_coeff-1][i_total_zeros] */
const VO_U8 total_zeros_Dc[3][4] =
{
    {0x11,/*1*/0x12,/*01*/0x13,/*001*/0x03/*000*/},
    {0x11,/*1*/0x12,/*01*/0x02/*00*/},
    {0x11,/*1*/0x01/*0*/}
};

/* RunBefore[__MIN( i_zero_left -1, 6 )][run_before] */
const VO_U8 run_before[7][15] =
{
    {0x11,/*1*/0x01/*0*/},// 1
    {0x11,/*1*/0x12,/*01*/0x02/*00*/},// 2
    {0x32,/*11*/0x22,/*10*/0x12,/*01*/0x02/*00*/},// 3
    {0x32,/*11*/0x22,/*10*/0x12,/*01*/0x13,/*001*/0x03/*000*/},// 4
    {0x32,/*11*/0x22,/*10*/0x33,/*011*/0x23,/*010*/0x13,/*001*/0x03/*000*/},// 5
    {0x32,/*11*/0x03,/*000*/0x13,/*001*/0x33,/*011*/0x23,/*010*/0x53,/*101*/0x43/*100*/},// 6
    {0x73,/*111*/0x63,/*110*/0x53,/*101*/0x43,/*100*/0x33,/*011*/0x23,/*010*/0x13,/*001*/0x14,/*0001*/0x15,/*00001*/
     0x16,/*000001*/0x17,/*0000001*/0x18,/*00000001*/0x19,/*000000001*/0x1a,/*0000000001*/0x1b/*00000000001*/},// >6
};

/****************************************************************************************************************************************************/
//cavlc


#ifndef RDO_SKIP_BS
#define RDO_SKIP_BS 0
#endif


static const VO_U8 InterCBPGolomb[48]=
{
  0,  2,  3,  7,  4,  8, 17, 13,  5, 18,  9, 14, 10, 15, 16, 11,
  1, 32, 33, 36, 34, 37, 44, 40, 35, 45, 38, 41, 39, 42, 43, 19,
  6, 24, 25, 20, 26, 21, 46, 28, 27, 47, 22, 29, 23, 30, 31, 12
};

#define WriteVLC(s,v) PutBits( s, (v)&0x0f, (v)>>4 )
#define WriteVLCPlus(s,v) PutBits( s, ((v)&0x0f)+1, (v)>>4 )


static VO_S32 GetRunLevelInfo( VO_S16 *dct,VO_S16* level,VO_U8* run,VO_S32 count,VO_S32* total_zero)
{
    VO_S32 total = 0;
	VO_S32 zero;
	VO_S32 last ;
	for( last = count; last >= 3; last -= 4 )
        if( M64( dct+last-3 ) )
            break;
    while( last >= 0 && dct[last] == 0 )
        last--;
	zero = last+1;

    do
    {
        VO_S32 r_count = 0;
        level[total] = dct[last];
        while( --last >= 0 && dct[last] == 0 )
            r_count++;
        run[total++] = (VO_U8)r_count;
    } while( last >= 0 );
	*total_zero = zero - total;
    return total;
}

static VOINLINE VO_S32 WriteBlkResidualCavlcEscape( BS_TYPE *s, VO_S32 suffix_length, VO_S32 level )
{
    static const VO_U16 NextSuffix[7] = { 0, 3, 6, 12, 24, 48, 0xffff };
    VO_S32 mask = level >> 15;
    VO_S32 abs_level = (level^mask)-mask-1;
	int shift = suffix_length - 1;        
  	int escape = (15 << shift);
	
	if (abs_level < escape)
  	{
    	int sufmask   = ~((0xffffffff) << shift);
    	int suffix    = (abs_level) & sufmask;

		PutBits( s, ((abs_level) >> shift) + 1 + suffix_length, (2 << shift) | (suffix << 1) | (mask&1) );
  	}
 	else
  	{
  		int iMask = 4096;
    	int levabsesc = abs_level - escape + 2048;
    	int numPrefix = 0;
		if ((levabsesc) >= 4096)
    	{
      		numPrefix++;
      		while ((levabsesc) >= (4096 << numPrefix))
      		{
        		numPrefix++;
      		}
    	}

    	iMask <<= numPrefix;
		PutBits( s, 28 + (numPrefix << 1), iMask | ((levabsesc << 1) - iMask) | (mask&1) );
  	}
	
	suffix_length = suffix_length ? suffix_length : suffix_length+1;
	suffix_length = abs_level > NextSuffix[suffix_length] ? suffix_length+1 : suffix_length;
	
    return suffix_length;
}

static VO_S32 WriteResidualCavlc( H264ENC *pEncGlobal, VO_S32 ctx_block_cat, VO_S16 *l, VO_S32 nC )
{
  BS_TYPE *s = &pEncGlobal->out.bs;
  static const VO_U8 trailing_count[8] = {3,2,1,1,0,0,0,0};
  static const VO_S32 coeffs_count[5] = {16, 15, 16, 4, 15};
    
  VO_S32 trailing, total_zero, suffix_length, i;
  VO_S32 total_coeffs = 0;
  VO_S32 max_coeffs = coeffs_count[ctx_block_cat];
  VO_U32 sign;
  VO_S16 level[16];
  VO_U8 run[16];
  level[1] = 2;
  level[2] = 2;
  total_coeffs = GetRunLevelInfo( l, level,run,max_coeffs-1,&total_zero);

  trailing = ((((level[0]+1) | (1-level[0])) >> 31) & 4) | ((((level[1]+1) | (1-level[1])) >> 31) & 2)
             | ((((level[2]+1) | (1-level[2])) >> 31) & 1);
  trailing = trailing_count[trailing];
  sign = ((level[2] >> 31) & 1)|((level[1] >> 31) & 2)|((level[0] >> 31) & 4);
  sign >>= 3-trailing;

  //TotalCoeff/TrailingOnes
  if(nC==0)
    WriteVLCPlus( s, coeff_token[0][((total_coeffs-1)<<2)+trailing] );
  else if(nC<3)
	WriteVLC( s, coeff_token[nC][((total_coeffs-1)<<2)+trailing] );
  else if(nC==3)
    PutBits( s, 6, ((total_coeffs-1)<<2)+trailing);
  else
	WriteVLC( s, coeff_token_CDC[((total_coeffs-1)<<2)+trailing] );
  //sign
  PutBits( s, trailing, sign );
  //level
  suffix_length = total_coeffs > 10 && trailing < 3;
  if( trailing < total_coeffs )
  {
    VO_S16 val = level[trailing];
    VO_S16 orig_val = level[trailing]+LEVEL_SIZE/2;
    if( trailing < 3 )
      val -= (val>>15)|1;
    val += LEVEL_SIZE/2;

    if( (unsigned)orig_val < LEVEL_SIZE )
    {
      LEVEL_TYPE cur_level = level_table[suffix_length][val];
	  PutBits( s,  cur_level.len,cur_level.val );
	  suffix_length = level_table[suffix_length][orig_val].suffix;
    }
    else
    {
      suffix_length = WriteBlkResidualCavlcEscape( &pEncGlobal->out.bs, suffix_length, val-LEVEL_SIZE/2 );
    }
    for( i = trailing+1; i < total_coeffs; i++ )
    {
      val = level[i] + LEVEL_SIZE/2;
      if( (unsigned)val < LEVEL_SIZE )
      {
        LEVEL_TYPE cur_level = level_table[suffix_length][val];
                PutBits( s,  cur_level.len,cur_level.val );
                suffix_length = cur_level.suffix;
      }
      else
      {
        suffix_length = WriteBlkResidualCavlcEscape( &pEncGlobal->out.bs, suffix_length, level[i] );
      }
	}
  }
  //TotalZeros
  if( total_coeffs < max_coeffs )
  {
    if( ctx_block_cat == CAVLC_CHROMA_DC )
      WriteVLC( s, total_zeros_Dc[total_coeffs-1][total_zero] );
    else
      WriteVLC( s, total_zeros[total_coeffs-1][total_zero] );
  }
  //RunBefore
  for( i = 0; i < total_coeffs-1 && total_zero > 0; i++ )
  {
    VO_S32 zero_left = AVC_MIN( total_zero, 7 );
    WriteVLC( s, run_before[zero_left-1][run[i]] );
    total_zero -= run[i];
  }

  return total_coeffs;
}

static const VO_U8 CTIdx[17] = {0,0,1,1,2,2,2,2,3,3,3,3,3,3,3,3,3};

#define WriteBlkResidualCavlc(pEncGlobal,cat,idx,l)\
{\
    VO_S32 nC = cat == CAVLC_CHROMA_DC ? 4 : CTIdx[PredictMBNZC( pEncGlobal, cat == CAVLC_LUMA_DC ? 0 : idx )];\
    VO_U8 *nnz = &pEncGlobal->mb.exmb_nzc[cache_pos[idx]];\
    if( !*nnz )\
        WriteVLC( &pEncGlobal->out.bs, coeff_token0[nC] );\
    else\
        *nnz = (VO_U8)(WriteResidualCavlc(pEncGlobal,cat,l,nC));\
}
#define DC_POS 44
static void WriteQPDeltaCavlc( H264ENC *pEncGlobal , H264ENC_L *pEncLocal)
{
  BS_TYPE *s = &pEncGlobal->out.bs;
  VO_S32 delta_qp = pEncLocal->nQP - pEncLocal->nLastQP;

  /* Avoid writing a delta quant if we have an empty i16x16 block, e.g. in a completely flat background area */
  if( pEncLocal->nMBType == I16x16 && !(pEncLocal->nLumaCBP | pEncLocal->nChromaCBP)
      && !pEncGlobal->mb.exmb_nzc[DC_POS] )
  {
#if !RDO_SKIP_BS
	pEncLocal->nQP = pEncLocal->nLastQP;
#endif
    delta_qp = 0;
  }

  if( delta_qp )
  {
    if( delta_qp < -26 )
      delta_qp += 52;
    else if( delta_qp > 25 )
      delta_qp -= 52;
  }
  SEBits( s, delta_qp );
}
#undef DC_POS
#define MV_POS 12
static void WriteMVDCavlc( H264ENC *pEncGlobal, VO_S32 width )
{
  BS_TYPE *s = &pEncGlobal->out.bs;
  SEBits( s, pEncGlobal->mb.mv[MV_POS][0] - pEncGlobal->mb.mvp[0] );
  SEBits( s, pEncGlobal->mb.mv[MV_POS][1] - pEncGlobal->mb.mvp[1] );
}
#undef MV_POS
static VOINLINE void WriteLumaCavlc( H264ENC *pEncGlobal, VO_S32 start, VO_S32 end , H264ENC_L *pEncLocal)
{
  VO_S32 i8x8, i4x4;

  for( i8x8 = start; i8x8 <= end; i8x8++ )
    if(pEncLocal->nLumaCBP & (1 << i8x8) )
      for( i4x4 = i8x8*4; i4x4 < i8x8*4+4; i4x4++ )
        WriteBlkResidualCavlc( pEncGlobal, CAVLC_LUMA_4x4, i4x4, pEncGlobal->dct.ac_4x4[i4x4] );
}

void WriteMBCavlc( H264ENC *pEncGlobal , H264ENC_L *pEncLocal)
{
  BS_TYPE *s = &pEncGlobal->out.bs;
  const VO_S32 i_mb_type = pEncLocal->nMBType;
  VO_S32 mb_offset = pEncGlobal->pic_type == P_PIC_TYPE ? 5 : 0;
  VO_S32 i;
  if( i_mb_type == I16x16 )
  {
    UEBits( s, mb_offset + 1 + intra_luma_mode_index[pEncLocal->nLumaMode] +
           pEncLocal->nChromaCBP * 4 + ( pEncLocal->nLumaCBP == 0 ? 0 : 12 ) );
    UEBits( s, intra_chroma_mode_index[pEncLocal->nChormaMode] );
  }
  else if( i_mb_type == PL0 )
  {
    //  if( pEncGlobal->mb.i_partition == D_16x16 )
    PutBit( s, 1 );
    WriteMVDCavlc( pEncGlobal,4 );
  }
  if( i_mb_type != I16x16 )
    UEBits( s, InterCBPGolomb[( pEncLocal->nChromaCBP << 4 )|pEncLocal->nLumaCBP] );

  // write residual 
  if( i_mb_type == I16x16 )
  {
    WriteQPDeltaCavlc( pEncGlobal, pEncLocal );

    // DC Luma 
    WriteBlkResidualCavlc( pEncGlobal, CAVLC_LUMA_DC, 24 , pEncGlobal->dct.luma_dc );
    //AC Luma 
    if( pEncLocal->nLumaCBP )
      for( i = 0; i < 16; i++ )
        WriteBlkResidualCavlc( pEncGlobal, CAVLC_LUMA_AC, i, pEncGlobal->dct.ac_4x4[i]+1 );
  }
  else if( pEncLocal->nLumaCBP | pEncLocal->nChromaCBP )
  {
    WriteQPDeltaCavlc( pEncGlobal, pEncLocal );
    WriteLumaCavlc( pEncGlobal, 0, 3 , pEncLocal);
  }
  if( pEncLocal->nChromaCBP )
  {
    // Chroma DC residual present 
    WriteBlkResidualCavlc( pEncGlobal, CAVLC_CHROMA_DC, 25, pEncGlobal->dct.chroma_dc[0] );
    WriteBlkResidualCavlc( pEncGlobal, CAVLC_CHROMA_DC, 26, pEncGlobal->dct.chroma_dc[1] );
	// Chroma AC 
    if( pEncLocal->nChromaCBP&0x02 ) 
      for( i = 16; i < 24; i++ )
        WriteBlkResidualCavlc( pEncGlobal, CAVLC_CHROMA_AC, i, pEncGlobal->dct.ac_4x4[i]+1 );
  }

}

