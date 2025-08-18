# SPDX-License-Identifier: GPL-2.0-only
include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=amlogic
SUBTARGET:=mesongx
DEVICE_TYPE:=other

include $(INCLUDE_DIR)/target.mk

# 设备定义
define Device/oes_a311d_box
  DEVICE_VENDOR := OES
  DEVICE_MODEL := A311D Box
  DEVICE_DTS := meson-a311d-oes-box
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

# 核心修改：在 kernel 编译前强制执行DTS复制脚本
define Kernel/Prepare
    # 调用默认的内核准备流程
    $(call Kernel/Prepare/Default)
    # 执行DTS复制脚本（使用绝对路径确保找到脚本）
    sh /builder/openwrt/target/linux/amlogic/mesongx/files/dts-copy.sh
    # 验证复制结果（失败则终止编译）
    if [ ! -f "$(LINUX_DIR)/arch/arm64/boot/dts/amlogic/meson-a311d-oes-box.dts" ]; then \
        echo "ERROR: 最终验证失败，DTS文件仍不存在！" >&2; \
        exit 1; \
    fi
endef

$(eval $(call BuildTarget))
    
