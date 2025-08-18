# SPDX-License-Identifier: GPL-2.0-only
include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=amlogic
SUBTARGET:=mesongx
DEVICE_TYPE:=other

include $(INCLUDE_DIR)/target.mk

# 设备定义：oes_a311d_box
define Device/oes_a311d_box
  DEVICE_VENDOR := OES
  DEVICE_MODEL := A311D Box
  DEVICE_DTS := meson-a311d-oes-box  # 匹配DTS文件名
  DEVICE_PACKAGES := \
    kmod-amlogic-eth \
    kmod-usb-dwc3 \
    kmod-usb-xhci-hcd \
    kmod-usb-storage \
    kmod-usb-storage-uas \
    kmod-fb
  IMAGE/sysupgrade.img.gz := boot-common | amlogic-sdcard | gzip | append-metadata
endef
TARGET_DEVICES += oes_a311d_box

# 核心：DTS文件复制规则（增强版）
# 1. 明确DTS源目录和目标目录（添加调试输出）
DTS_SOURCE_DIR := $(CURDIR)/dts
DTS_TARGET_DIR := $(LINUX_DIR)/arch/arm64/boot/dts/amlogic

# 2. 定义DTS安装规则（添加文件存在性检查和调试信息）
define Build/InstallDev
	# 输出当前路径，验证变量正确性
	$(info "=== 开始复制DTS文件 ===")
	$(info "DTS源目录: $(DTS_SOURCE_DIR)")
	$(info "DTS目标目录: $(DTS_TARGET_DIR)")

	# 检查源DTS文件是否存在（关键：若不存在直接报错，避免后续隐式失败）
	if [ ! -f "$(DTS_SOURCE_DIR)/meson-a311d-oes-box.dts" ]; then \
		$(error "ERROR: 源DTS文件不存在: $(DTS_SOURCE_DIR)/meson-a311d-oes-box.dts"); \
	fi

	# 创建目标目录（若不存在）
	mkdir -p $(DTS_TARGET_DIR)

	# 复制DTS和DTSI文件（添加-v选项输出复制过程，方便调试）
	$(CP) -v $(DTS_SOURCE_DIR)/*.dts $(DTS_TARGET_DIR)/
	$(CP) -v $(DTS_SOURCE_DIR)/*.dtsi $(DTS_TARGET_DIR)/

	# 验证目标目录是否已存在DTS文件
	if [ ! -f "$(DTS_TARGET_DIR)/meson-a311d-oes-box.dts" ]; then \
		$(error "ERROR: DTS文件复制失败，目标路径不存在: $(DTS_TARGET_DIR)/meson-a311d-oes-box.dts"); \
	fi

	$(info "=== DTS文件复制完成 ===")
endef

# 3. 强制DTS安装在kernel准备阶段（绑定到内核准备标志文件，确保最早执行）
# $(LINUX_DIR)/.prepared 是内核源码准备完成的标志，在编译前一定会生成
$(LINUX_DIR)/.prepared: $(eval $(call Build/InstallDev))

$(eval $(call BuildTarget))
