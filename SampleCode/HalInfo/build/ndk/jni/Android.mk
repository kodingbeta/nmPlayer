# Copyright (C) 2009 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
LOCAL_PATH := $(call my-dir)
VOTOP?=../../../../..

include $(CLEAR_VARS)

LOCAL_MODULE    := cpu_info
LOCAL_CFLAGS := -D_LINUX -D__VO_NDK__
LOCAL_C_INCLUDES := -I ../../../../../Include \
	            -I ../../../../../Common

LOCAL_SRC_FILES := ../../../../../Common/voHalInfo.cpp \
		   ../../../main.cpp
include $(BUILD_EXECUTABLE)
