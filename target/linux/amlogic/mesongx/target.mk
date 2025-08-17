# 文件：target/linux/amlogic/mesongx/target.mk
ARCH:=aarch64
SUBTARGET:=mesongx
BOARDNAME:=Amlogic Meson GX/G12B (64-bit)
FEATURES+=64bit

# 设备CPU类型（仅用于标识，不直接绑定工具链参数）
CPU_TYPE:=cortex-a73.cortex-a53

KERNEL_PATCHVER:=5.15

# 核心：强制固件编译参数，过滤工具链默认的-mcpu
TARGET_CFLAGS := \
	$(filter-out -mcpu=%,$(TARGET_CFLAGS)) \
	-march=armv8-a+simd \
	-mtune=cortex-a73.cortex-a53

# 为不同核心设置差异化优化（新增）
TARGET_CFLAGS_BIG := -march=armv8.2-a+simd
TARGET_CFLAGS_LITTLE := -march=armv8-a+simd

# A311D 硬件专属驱动
DEFAULT_PACKAGES += \
	ethtool parted kmod-fb \
	kmod-crypto-amlogic \
	kmod-amlogic-thermal \
	kmod-video-amlogic-vpu \
	amlogic-cpufreq \
	amlogic-gpu-driver

define Target/Description
	Build firmware for Amlogic A311D (4x Cortex-A73 + 2x Cortex-A53 big.LITTLE).
	Optimized for ARMv8-A instruction set with hardware acceleration.
endef
