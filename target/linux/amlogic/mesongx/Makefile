# SPDX-License-Identifier: GPL-2.0-only
include $(TOPDIR)/rules.mk  # 必须包含的顶层规则

# 架构信息（与主Makefile完全匹配）
ARCH:=aarch64
BOARD:=amlogic
SUBTARGET:=mesongx
DEVICE_TYPE:=other

# 必须包含的设备模板
include $(INCLUDE_DIR)/target.mk

# 设备定义（无任何语法错误）
define Device/oes_a311d_box
  DEVICE_VENDOR := OES
  DEVICE_MODEL := A311D Box
  DEVICE_DTS := meson-a311d-oes-box  # 与.dts文件一致
  DEVICE_PACKAGES := kmod-amlogic-eth-g12b kmod-usb3
  IMAGE/sysupgrade.img.gz := boot-common | amlogic-sdcard | gzip | append-metadata
endef

# 设备注册（必须有）
TARGET_DEVICES += oes_a311d_box

# 固定格式的构建目标
$(eval $(call BuildTarget))