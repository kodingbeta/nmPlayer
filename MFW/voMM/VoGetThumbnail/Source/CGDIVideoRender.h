	/************************************************************************
	*																		*
	*		VisualOn, Inc. Confidential and Proprietary, 2003 - 2009		*
	*																		*
	************************************************************************/
/*******************************************************************************
	File:		CGDIVideoRender.h

	Contains:	CGDIVideoRender header file

	Written by:	Bangfei Jin

	Change History (most recent first):
	2008-04-30		JBF			Create file

*******************************************************************************/

#ifndef __CGDIVideoRender_H__
#define __CGDIVideoRender_H__

#include <windows.h>

#include ".\CBaseVideoRender.h"

#define iMASK_COLORS 3
#define SIZE_MASKS (iMASK_COLORS * sizeof(DWORD))

class CGDIVideoRender : public CBaseVideoRender
{
public:
	// Used to control the image drawing
	CGDIVideoRender (VO_PTR hInst, VO_PTR hView, VO_MEM_OPERATOR * pMemOP);
	virtual ~CGDIVideoRender (void);

	virtual VO_U32 Render (VO_VIDEO_BUFFER * pVideoBuffer, VO_S64 nStart, VO_BOOL bWait);
	virtual VO_U32 Redraw (void);

	virtual VO_U32 	GetVideoMemOP (VO_MEM_VIDEO_OPERATOR ** ppVideoMemOP);

	virtual VO_U32 	Start (void);
	virtual VO_U32 	Pause (void);
	virtual VO_U32 	Stop (void);
	VO_U32			GetBitmap( HBITMAP* hOutBitmap);
	//VO_U32			GetBitmapBuffer( LPBYTE* pBitmapBuufer);
	//VO_U32			GetBitmapInfo( HBITMAP* hOutBitmap);
	virtual bool	ConvertData (VO_VIDEO_BUFFER * pInBuffer, VO_VIDEO_BUFFER * pOutBuffer, VO_S64 nStart, VO_BOOL bWait);

protected:
	virtual VO_U32	UpdateSize (void);
	bool			CreateBitmapInfo (int nW =-1, int nH=-1);

	virtual VO_U32  ShowOverlay(VO_BOOL bShow);
protected:
	HDC				m_hWinDC;
	HDC				m_hMemDC;

	HBITMAP			m_hBitmap;
	HBITMAP			m_hOldBmp;
	LPBYTE			m_pBmpInfo;
	LPBYTE			m_pBitmapBuffer;

	VO_U32			m_nGDIWidth;
	VO_U32			m_nGDIHeight;
	VO_U32			m_nPixelBits;

	VO_VIDEO_BUFFER	m_outBuffer;
	bool			m_bDeleteBmpOnQuit;
};

#endif // __CGDIVideoRender_H__