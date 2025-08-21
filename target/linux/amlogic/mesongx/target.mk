# 文件：target/linux/amlogic/mesongx/target.mk
ARCH:=aarch64
SUBTARGET:=mesongx
BOARDNAME:=Amlogic Meson GX/G12B (64-bit)
FEATURES+=64bit

# 设备CPU类型（用于构建系统的标识和选择内核配置，不直接传递给工具链）
CPU_TYPE:=cortex-a73.cortex-a53

KERNEL_PATCHVER:=5.15

# 核心优化参数：兼顾性能、兼容性与稳定性
TARGET_CFLAGS += \
    -mcpu=cortex-a73.cortex-a53 \
    -O3 \
    -flto \
    -mfix-cortex-a53-835769 \
    -mfix-cortex-a53-843419

# 链接器标志：必须也启用LTO以完成整个优化流程
TARGET_LDFLAGS += -flto

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
