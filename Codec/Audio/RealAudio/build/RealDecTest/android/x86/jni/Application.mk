# Build both ARMv5TE and ARMv7-A machine code.
APP_CFLAGS := -O3
APP_ABI := x86

# release/debug
APP_OPTIM?= release

# VisualOn Info
VOMODVER ?= 3.0.0
VOBRANCH ?= trunk 
VOSRCNO ?= 11902
VOBUILDTOOL ?= NDKr6b
VOBUILDNUM ?= 0000
VOGPVER ?= 3.3.18
