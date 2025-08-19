# 文件：target/linux/amlogic/mesongx/target.mk
ARCH:=aarch64
SUBTARGET:=mesongx
BOARDNAME:=Amlogic Meson GX/G12B (64-bit)
FEATURES+=64bit

# 设备CPU类型（仅用于标识，不直接绑定工具链参数）
CPU_TYPE:=cortex-a73.cortex-a53

KERNEL_PATCHVER:=5.15

TARGET_CFLAGS += \
    -march=armv8.0-a+crypto+simd+fp16 \  # 基础指令集+扩展（A53兼容）
    -mcpu=cortex-a73 \                    # 针对A73微架构优化（不影响指令集）
    -mtune=cortex-a73.cortex-a53 \        # 同时优化A73和A53的调度策略
    -mfpu=neon-fp-armv8 \                 # 匹配两者的NEON-FPU硬件
    -mfloat-abi=hard                      # 启用硬件浮点调用约定

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
