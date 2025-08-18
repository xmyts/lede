#  文件：target/linux/amlogic/mesongx/Makefile
# SPDX-License-Identifier: GPL-2.0-only
include $(TOPDIR)/rules.mk  # 引入顶层规则

# 架构与目标平台信息
ARCH:=aarch64
BOARD:=amlogic
SUBTARGET:=mesongx
DEVICE_TYPE:=other

# 引入目标设备通用模板
include $(INCLUDE_DIR)/target.mk

# 设备定义：oes_a311d_box
define Device/oes_a311d_box
  DEVICE_VENDOR := OES
  DEVICE_MODEL := A311D Box
  DEVICE_DTS := meson-a311d-oes-box  # 匹配DTS文件名
  # 设备所需的内核模块（根据硬件需求调整）
  DEVICE_PACKAGES := \
    kmod-amlogic-eth \
    kmod-usb-dwc3 \
    kmod-usb-xhci-hcd \
    kmod-usb-storage \
    kmod-usb-storage-uas \
    kmod-fb
  # 镜像生成规则（与image.mk中的定义对应）
  IMAGE/sysupgrade.img.gz := boot-common | amlogic-sdcard | gzip | append-metadata
endef

# 注册设备
TARGET_DEVICES += oes_a311d_box

# 关键：DTS文件安装到内核源码目录（确保内核编译时能找到DTS）
DTS_SOURCE_DIR := $(CURDIR)/dts  # DTS文件所在目录（你的dts文件夹路径）
DTS_TARGET_DIR := $(LINUX_DIR)/arch/arm64/boot/dts/amlogic  # 内核DTS目录
define Build/InstallDev
	# 创建内核DTS目标目录（若不存在）
	mkdir -p $(DTS_TARGET_DIR)
	# 复制所有DTS和DTSI文件到内核目录（包括依赖文件）
	$(CP) $(DTS_SOURCE_DIR)/*.dts $(DTS_TARGET_DIR)/
	$(CP) $(DTS_SOURCE_DIR)/*.dtsi $(DTS_TARGET_DIR)/
endef

# 构建目标声明
$(eval $(call BuildTarget))
