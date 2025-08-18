# 文件：target/linux/amlogic/mesongx/target.mk
ARCH:=aarch64
SUBTARGET:=mesongx
BOARDNAME:=Amlogic Meson GX/G12B (64-bit)
FEATURES+=64bit

# 设备CPU类型（用于工具链--with-cpu参数，匹配big.LITTLE架构）
CPU_TYPE:=cortex-a73.cortex-a53
# 架构版本（用于工具链--with-arch参数，对应ARMv8-A指令集）
ARCH_VERSION:=armv8-a
# 浮点类型（硬浮点，用于工具链--with-float参数）
FLOAT_TYPE:=hard
# 浮点单元（NEON，用于工具链--with-fpu参数）
FPU_TYPE:=neon
# ABI类型（aarch64默认ABI，用于工具链--with-abi参数）
ABI:=aarch64
# 额外架构参数（无特殊需求时留空）
EXTRA_ARCH_FLAGS:=

KERNEL_PATCHVER:=5.15

# 固件编译参数：与工具链参数保持一致，确保兼容性
TARGET_CFLAGS := \
	$(filter-out -mcpu=%,$(TARGET_CFLAGS)) \
	-march=$(ARCH_VERSION) \  # 引用ARCH_VERSION，与工具链一致
	-mtune=$(CPU_TYPE)        # 引用CPU_TYPE，与工具链一致

# 为大小核设置差异化优化（保持兼容性优先，复用统一的架构参数）
TARGET_CFLAGS_BIG := -march=$(ARCH_VERSION)
TARGET_CFLAGS_LITTLE := -march=$(ARCH_VERSION)

# A311D 硬件专属驱动（确保双核心协同工作）
DEFAULT_PACKAGES += \
	ethtool parted kmod-fb \
	kmod-crypto-amlogic \
	kmod-amlogic-thermal \
	kmod-video-amlogic-vpu \
	amlogic-cpufreq \
	amlogic-gpu-driver \
	kmod-cpufreq-dt \
	kmod-sched-core \
	kmod-cpu-cooling

define Target/Description
	Build firmware for Amlogic Meson GX/G12B series (64-bit), including A311D.
	Optimized for big.LITTLE architecture (4x Cortex-A73 + 2x Cortex-A53) with
	ARMv8-A instruction set compatibility. Supports hardware acceleration and
	thermal management for dual-core clusters.
endef
