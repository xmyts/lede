# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2014-2024 OpenWRT.org
# Copyright (C) 2024 Your Name <your-email@example.com>

include $(TOPDIR)/rules.mk

# 架构核心定义（保持与LEDE原配置一致）
BOARD:=amlogic
BOARDNAME:=Amlogic Meson family
FEATURES:=boot-part ext4 audio usb fpu legacy-sdcard squashfs gpio pci pcie display
SUBTARGETS:=meson8b mesongx  # 32位与64位子目标

# 全局内核版本定义（核心修复：确保所有子目标继承此版本）
KERNEL_PATCHVER:=5.15  # 必须与include/kernel-5.15匹配，根据源码实际支持版本调整

# 32位meson8b子目标配置
meson8b_TITLE:=Amlogic Meson8b (32-bit)
meson8b_FEATURES:=$(FEATURES)
meson8b_ARCH:=arm
meson8b_KERNEL_PATCHVER:=$(KERNEL_PATCHVER)  # 继承全局内核版本
meson8b_CPU_TYPE:=cortex-a5
meson8b_CPU_SUBTYPE:=vfpv4

# 64位mesongx子目标配置（核心修复：明确64位架构及内核版本）
mesongx_TITLE:=Amlogic Meson GX/G12B (64-bit)
mesongx_FEATURES:=$(FEATURES) 64bit  # 强制64位特性
mesongx_ARCH:=aarch64  # 64位架构标识
mesongx_KERNEL_PATCHVER:=$(KERNEL_PATCHVER)  # 继承全局内核版本，确保与32位一致
mesongx_CPU_TYPE:=cortex-a73
mesongx_CPU_SUBTYPE:=cortex-a53

# 架构描述（显示在menuconfig中）
define Target/Description
  Build firmware images for Amlogic Meson series SoCs:
  - 32-bit: meson8b (e.g., S805, S812)
  - 64-bit: mesongx (e.g., A311D, S922X, S905X4) with big.LITTLE architecture
  Supports SD card/USB disk images and eMMC installations.
endef

# 引入内核编译核心规则（必须，用于传递KERNEL_PATCHVER）
include $(INCLUDE_DIR)/kernel.mk
# 引入目标编译规则
include $(INCLUDE_DIR)/target.mk

# 通用默认包（所有子目标共用）
DEFAULT_PACKAGES += \
  e2fsprogs mkf2fs resize2fs partx-utils losetup \
  automount htop curl ca-certificates

# 32位专属包
meson8b_DEFAULT_PACKAGES += \
  autocore-arm kmod-crypto-arm

# 64位专属包（适配aarch64）
mesongx_DEFAULT_PACKAGES += \
  autocore-aarch64 kmod-crypto-arm64

# 内核镜像名称（Amlogic设备通用）
KERNELNAME:=Image dtbs

# 注册目标（固定格式）
$(eval $(call BuildTarget))