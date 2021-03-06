#ifndef VOCABAC_H
#define VOCABAC_H

#include "h265dec_cabac.h"
#include "h265dec_bits.h"
#include "h265_decoder.h"
#include "h265dec_utils.h"
#include <assert.h>
#include "HMLog.h"

#define CABAC_BITS 16
#define CABAC_MASK ((1<<CABAC_BITS)-1)


VO_U32 voCabacDecodeBin( H265_DEC_CABAC *p_cabac,/* BIT_STREAM* p_bs,*/VO_U32 nCtxState );
VO_U32 voCabacDecodeBinEP(H265_DEC_CABAC *p_cabac/*, BIT_STREAM* p_bs*/ );
VO_U32 voCabacDecodeBinsEP(H265_DEC_CABAC *p_cabac,/*BIT_STREAM* p_bs,*/ VO_S32 numBins );
VO_U32 voCabacDecodeBinTrm(H265_DEC_CABAC *p_cabac/*, BIT_STREAM* p_bs*/ );


VO_U32 xReadEpExGolomb( H265_DEC_CABAC *p_cabac,
	/*BIT_STREAM *p_bs,*/
	VO_U32 uiCount );
VO_U32 xReadCoefRemainExGolomb ( H265_DEC_CABAC *p_cabac, 
	/*BIT_STREAM* p_bs, */
	VO_U32 rParam );
VO_U32 xReadUnaryMaxSymbol( H265_DEC_CABAC *p_cabac,
    /*BIT_STREAM *p_bs,*/
	VO_U32 iBase, 
	VO_S32 iOffset, 
	VO_U32 uiMaxSymbol );





#endif