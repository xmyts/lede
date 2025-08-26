# 文件：target/linux/amlogic/mesongx/target.mk
# 文件：target/linux/amlogic/mesongx/target.mk
# 来源：deepseek oes盒子芯片a311d，CPU：采用 Big.Little 架构
ARCH:=aarch64
SUBTARGET:=mesongx
BOARDNAME:=Amlogic Meson GX/G12B (64-bit)
FEATURES+=64bit

CPU_TYPE:=cortex-a73.cortex-a53

KERNEL_PATCHVER:=5.15

# 核心优化参数：极致性能调优，针对A311D硬件特性
TARGET_CFLAGS += \
    -mcpu=cortex-a73 \
    -O3

# A311D 硬件专属驱动（确保所有硬件单元协同工作）
DEFAULT_PACKAGES += \
	ethtool parted kmod-fb \
	kmod-crypto-amlogic \
	kmod-amlogic-thermal \
	kmod-video-amlogic-vpu \
	amlogic-cpufreq \
	amlogic-gpu-driver \
	kmod-cpufreq-dt \
	kmod-sched-core \
	kmod-cpu-cooling \
	kmod-arm-cci \
	kmod-rng-amlogic \
	zram-swap \
	f2fs-tools

define Target/Description
	Build firmware for Amlogic Meson GX/G12B series (64-bit), including A311D.
	Optimized for big.LITTLE architecture (4x Cortex-A73 + 2x Cortex-A53) with
	ARMv8.2-A instruction set and CRC/Crypto extensions. Includes full hardware
	acceleration, thermal management, and scheduler support for dual-core clusters.
	Stripped and LTO-optimized for maximum performance and minimal size.
endef
