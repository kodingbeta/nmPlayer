LOCAL_PATH := $(call my-dir)
VOTOP?=../../../../../../..

include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm

LOCAL_MODULE :=libvoLiveSrcDASH

CMNSRC_PATH:=../../../../../../../Common

INCLUDE_PATH:=../../../../../../../Include

COMM_PATH:=../../../../../../../Common

CSRC_PATH:=../../../../../../../Source

LOCAL_SRC_FILES := \
	\
	$(COMM_PATH)/cmnMemory.c \
	$(COMM_PATH)/voCMutex.cpp \
	$(COMM_PATH)/voOSFunc.cpp \
	$(COMM_PATH)/voThread.cpp \
	$(COMM_PATH)/CvoBaseObject.cpp \
	$(COMM_PATH)/NetWork/vo_socket.cpp \
	$(COMM_PATH)/cmnFile.cpp \
	$(COMM_PATH)/CDllLoad.cpp \
	$(COMM_PATH)/voXMLLoad.cpp \
	$(COMM_PATH)/CPtrList.cpp \
	$(COMM_PATH)/voHalInfo.cpp \
	$(COMM_PATH)/fAudioHeadDataInfo.cpp \
	$(CSRC_PATH)/File/Common/fortest.cpp \
	$(CSRC_PATH)/dash2/vo_http_stream.cpp \
	$(CSRC_PATH)/dash2/vo_mpd_manager.cpp \
	$(CSRC_PATH)/dash2/vo_mpd_reader.cpp \
	$(CSRC_PATH)/dash2/vo_stream.cpp \
	$(CSRC_PATH)/dash2/vo_mem_stream.cpp \
	$(CSRC_PATH)/dash2/vo_mpd_streaming.cpp \
	$(CSRC_PATH)/File/Common/vo_thread.cpp \
	$(CSRC_PATH)/dash2/CLiveSrcDASH.cpp \
	$(CSRC_PATH)/dash2/vo_network_judgment.cpp \
	$(CSRC_PATH)/MTV/LiveSource/Common/voLiveSource.cpp \
	$(CSRC_PATH)/MTV/LiveSource/Common/CLiveSrcBase.cpp \
	$(CSRC_PATH)/MTV/LiveSource/Common/CLiveParserBase.cpp \
	$(CSRC_PATH)/MTV/LiveSource/Common/ConfigFile.cpp \
	$(CSRC_PATH)/MTV/LiveSource/Common/ChannelInfo.cpp \
	$(CSRC_PATH)/MTV/CMMB/TinyXML/tinystr.cpp \
	$(CSRC_PATH)/MTV/CMMB/TinyXML/tinyxml.cpp \
	$(CSRC_PATH)/MTV/CMMB/TinyXML/tinyxmlerror.cpp \
	$(CSRC_PATH)/MTV/CMMB/TinyXML/tinyxmlparser.cpp \
	../../../../../../../Utility/voutf8conv/voutf8conv.c \
	$(CSRC_PATH)/ASController/CASController.cpp \
	$(CSRC_PATH)/File/Common/voASControllerAPI.cpp \
	$(CSRC_PATH)/File/Common/CBitrateMap.cpp \
	$(COMM_PATH)/Buffer/voSourceBufferManager.cpp \
	$(COMM_PATH)/Buffer/voSourceDataBuffer.cpp \
	$(COMM_PATH)/Buffer/voSourceSubtitleDataBuffer.cpp \
	$(COMM_PATH)/Buffer/voSourceVideoDataBuffer.cpp
	
	
LOCAL_C_INCLUDES := \
		$(INCLUDE_PATH) \
		$(INCLUDE_PATH)/vome \
		$(COMM_PATH) \
		$(COMM_PATH)/NetWork \
		../../../../../../../MFW/voME/Common \
		$(CSRC_PATH)/dash2 \
		$(CSRC_PATH)/MTV/LiveSource/Common \
		$(CSRC_PATH)/File/SMTH \
		$(CSRC_PATH)/MTV/CMMB/TinyXML \
		../../../../../../../Utility/voutf8conv \
		$(CSRC_PATH)/File/XML \
		$(CSRC_PATH)/File/Common \
		/opt/android-ndk-r5b/sources/android/cpufeatures \
		$(CSRC_PATH)/ASController \
		$(COMM_PATH)/Buffer


LOCAL_STATIC_LIBRARIES := cpufeatures


VOMM:=-DLINUX -D_LINUX -DHAVE_PTHREADS -D_LINUX_ANDROID  -D_VOLOG_FUNC -D_DASH_SOURCE_ -D__VO_NDK__ -D_NEW_SOURCEBUFFER -D_VOLOG_ERROR  -D_VOLOG_WARNING -D_VOLOG_INFO #-D_VOLOG_RUN

# about info option, do not need to care it

LOCAL_CFLAGS :=  -DNDEBUG -mfloat-abi=softfp -march=armv6j -mtune=arm1136jf-s -mfpu=vfp
LOCAL_LDLIBS:=../../../../../../../Lib/ndk/libvoCheck.a -llog
include $(VOTOP)/build/vondk.mk
include $(BUILD_SHARED_LIBRARY)

$(call import-module,cpufeatures)

