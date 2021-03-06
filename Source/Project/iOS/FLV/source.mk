

CMNSRC_PATH:=../../../../../Common
CSRC_PATH:=../../../../File/FLV
CSRCMN_PATH:=../../../../File/Common
CMDSRC_PATH:=../../../../File/MetaData
SRCMAINCMN_PATH:=../../../../Common
SOURCEINC_PATH:=../../../../Include

# please list all objects needed by your module here
VOMSRC:= \
	$(CMNSRC_PATH)/cmnFile.cpp \
	$(CMNSRC_PATH)/cmnVOMemory.cpp \
	$(CMNSRC_PATH)/voLog.c \
	$(CMNSRC_PATH)/voOSFunc_iOS.mm \
	$(CMNSRC_PATH)/CvoBaseObject.cpp \
	$(CMNSRC_PATH)/voCMutex.cpp \
	$(CMNSRC_PATH)/fVideoHeadDataInfo.cpp \
	$(CMNSRC_PATH)/voCSemaphore.cpp \
	$(CMNSRC_PATH)/voProgramInfo.cpp \
	$(CSRC_PATH)/CFlvAudioTrack.cpp \
	$(CSRC_PATH)/CFlvParser.cpp \
	$(CSRC_PATH)/CFlvReader.cpp \
	$(CSRC_PATH)/CFlvTrack.cpp \
	$(CSRC_PATH)/CFlvVideoTrack.cpp \
	$(CSRCMN_PATH)/CBaseReader.cpp \
	$(CSRCMN_PATH)/CBaseStreamFileIndex.cpp \
	$(CSRCMN_PATH)/CBaseStreamFileReader.cpp \
	$(CSRCMN_PATH)/CBaseStreamFileTrack.cpp \
	$(CSRCMN_PATH)/CBaseTrack.cpp \
	$(CSRCMN_PATH)/CGBuffer.cpp \
	$(CSRCMN_PATH)/CGFileChunk.cpp \
	$(CSRCMN_PATH)/CMemPool.cpp \
	$(CSRCMN_PATH)/CSourceIOSwitch.cpp \
	$(CSRCMN_PATH)/CvoBaseDrmCallback.cpp \
	$(CSRCMN_PATH)/CvoBaseFileOpr.cpp \
	$(CSRCMN_PATH)/CvoBaseMemOpr.cpp \
	$(CSRCMN_PATH)/CvoFileParser.cpp \
	$(CSRCMN_PATH)/fCodec.cpp \
	$(CSRCMN_PATH)/voFileReader.cpp \
	$(CSRCMN_PATH)/voSource2WrapperPushPlay.cpp \
	$(CSRCMN_PATH)/voSource2WrapperManager.cpp \
	$(CSRCMN_PATH)/voSourceBaseWrapper.cpp \
	$(CSRCMN_PATH)/voSource2ParserWrapper.cpp \
	$(SRCMAINCMN_PATH)/Buffer/voSourceBufferManager.cpp \
	$(SRCMAINCMN_PATH)/Buffer/voSourceDataBuffer.cpp \
	$(SRCMAINCMN_PATH)/Buffer/voSourceSubtitleDataBuffer.cpp \
	$(SRCMAINCMN_PATH)/Buffer/voSourceVideoDataBuffer.cpp \
	$(SRCMAINCMN_PATH)/vo_thread.cpp

# please list all directories that all source files relative with your module(.h .c .cpp) locate 
VOSRCDIR:= \
	../../../../../Include \
	$(CSRC_PATH) \
	$(CMNSRC_PATH) \
	$(CSRCMN_PATH) \
	$(CMDSRC_PATH) \
	$(SOURCEINC_PATH) \
	$(SRCMAINCMN_PATH) \
	$(SRCMAINCMN_PATH)/Buffer