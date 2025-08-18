# SPDX-License-Identifier: GPL-2.0-only
include $(TOPDIR)/rules.mk  # 引入顶层构建规则

# 架构与目标平台基础信息（必须与内核架构匹配）
ARCH:=aarch64
BOARD:=amlogic
SUBTARGET:=mesongx
DEVICE_TYPE:=other

# 引入目标设备通用模板（提供设备定义的基础规则）
include $(INCLUDE_DIR)/target.mk

# 设备具体定义：oes_a311d_box（核心设备配置）
define Device/oes_a311d_box
  DEVICE_VENDOR := OES  # 厂商名称
  DEVICE_MODEL := A311D Box  # 设备型号
  DEVICE_DTS := meson-a311d-oes-box  # 设备树文件名（与dts目录下的文件一致）
  # 设备必需的内核模块（根据硬件外设配置，确保驱动被包含）
  DEVICE_PACKAGES := \
    kmod-amlogic-eth \
    kmod-usb-dwc3 \
    kmod-usb-xhci-hcd \
    kmod-usb-storage \
    kmod-usb-storage-uas \
    kmod-fb
  # 镜像生成规则（与image.mk中的镜像流程关联）
  IMAGE/sysupgrade.img.gz := boot-common | amlogic-sdcard | gzip | append-metadata
endef

# 注册设备到构建系统（必须执行，否则设备不被识别）
TARGET_DEVICES += oes_a311d_box

# 关键修改1：明确DTS文件的源目录和内核目标目录
# $(CURDIR) 指向当前Makefile所在目录（target/linux/amlogic/mesongx/）
DTS_SOURCE_DIR := $(CURDIR)/dts  # DTS文件实际存放路径（含meson-a311d-oes-box.dts）
# $(LINUX_DIR) 由OpenWrt自动定义，指向内核源码目录（如build_dir/.../linux-5.15.189/）
DTS_TARGET_DIR := $(LINUX_DIR)/arch/arm64/boot/dts/amlogic  # 内核编译时查找DTS的路径

# 关键修改2：定义DTS文件的安装规则（确保在 kernel 编译前执行）
# Build/InstallDev 是OpenWrt的特殊规则，用于在"开发阶段"安装文件（内核编译前触发）
define Build/InstallDev
	# 1. 创建内核DTS目标目录（若不存在，避免复制失败）
	mkdir -p $(DTS_TARGET_DIR)
	# 2. 复制所有DTS文件到内核目录（包括目标设备的meson-a311d-oes-box.dts）
	$(CP) $(DTS_SOURCE_DIR)/*.dts $(DTS_TARGET_DIR)/
	# 3. 复制依赖的DTSI文件（设备树头文件，如meson-a311d.dtsi，避免编译DTS时缺失）
	$(CP) $(DTS_SOURCE_DIR)/*.dtsi $(DTS_TARGET_DIR)/
endef

# 关键修改3：确保DTS安装规则被内核编译依赖
# 强制内核编译前先执行Build/InstallDev（解决"先复制DTS，再编译内核"的顺序问题）
$(LINUX_DIR)/.config: $(eval $(call Build/InstallDev))

# 声明构建目标（OpenWrt固定格式，触发设备构建）
$(eval $(call BuildTarget))
