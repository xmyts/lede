# SPDX-License-Identifier: GPL-2.0-only
include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=amlogic
SUBTARGET:=mesongx
DEVICE_TYPE:=other

include $(INCLUDE_DIR)/target.mk

# 仅保留设备定义，DTS复制逻辑已迁移到image/Makefile
define Device/oes_a311d_box
  DEVICE_VENDOR := OES
  DEVICE_MODEL := A311D Box
  DEVICE_DTS := meson-a311d-oes-box  # 关联设备树文件名
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

$(eval $(call BuildTarget))
