						#################################################################
						#  									Visualon Makefile Template  							 	#
						#																																#
						#						(Please Keep Below Options Order Unchanged)					#
						#################################################################

# target type
# available: pc, v4(armv4), v5(armv5), v5x(armv5 xscale), v6(armv6), v7(cortex-a8 neon)
VOTT:= v7
 

#top root path
VOTOP:=../../../../../../..


# module type
# please specify the type of your module: lib or exe
VOMT:= lib


# module macros
# please append the additional macro definitions here for your module if necessary. 
# e.g. -DVISUALON, macro VISUALON defined for your module 

ifeq ($(VOTT), v6)
VOMM:=-D_IOS -D_VOMODULEID=0x02230000  -DARM -DARMV6 -D_ARM_ -DBUILD_WITHOUT_C_LIB -DBUILD_INTEGER -DDISABLE_UES -DENABLE_LPC -DENABLE_ALL_ENCOPT -DWMA_DECPK_BUILD
endif				

ifeq ($(VOTT), v7)
VOMM:=-D_IOS -D_VOMODULEID=0x02230000  -DARM -DARMV7 -D_ARM_ -DBUILD_WITHOUT_C_LIB -DBUILD_INTEGER -DDISABLE_UES -DENABLE_LPC -DENABLE_ALL_ENCOPT -DWMA_DECPK_BUILD
endif	

ifeq ($(VOTT), v7s)
VOMM:=-D_IOS -D_VOMODULEID=0x02230000  -DARM -DARMV7 -D_ARM_ -DBUILD_WITHOUT_C_LIB -DBUILD_INTEGER -DDISABLE_UES -DENABLE_LPC -DENABLE_ALL_ENCOPT -DWMA_DECPK_BUILD
endif

# please specify the name of your module
VOTARGET:= libvoWMADec
VOSRCNO:=28269

# please modify here to be sure to see the eclair.mk
include $(VOTOP)/build/ios.mk 

# dependent libraries.
VODEPLIBS:=-ldl -lstdc++ 

# module source
# please modify here to be sure to see the ms.mk which specifies all source info of your module
include ../ms.mk


# please specify where is the$(VOTOP)/../voRelease on your PC, relative path is suggested
VORELDIR=$(VOTOP)/../voRelease/iOS/static/v7


# please modify here to be sure to see the doit.mk
include $(VOTOP)/build/idoit.mk 


