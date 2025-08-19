#  文件：target/linux/amlogic/mesongx/Makefile
# SPDX-License-Identifier: GPL-2.0-only
include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=amlogic
SUBTARGET:=mesongx
DEVICE_TYPE:=other

include $(INCLUDE_DIR)/target.mk

# 设备定义：更新设备树文件名
define Device/oes_a311d_box  # 设备名称可保留，也可改为与新DTS匹配的名称（如gtking_pro）
  DEVICE_VENDOR := OES  # 可根据实际设备厂商修改
  DEVICE_MODEL := GTKing Pro  # 建议同步更新设备型号，与DTS名称对应
  DEVICE_DTS := meson-g12b-gtking-pro  # 核心：改为新的设备树文件名（无.dts后缀）
  DEVICE_PACKAGES := \
    kmod-amlogic-eth \
    kmod-usb-dwc3 \
    kmod-usb-xhci-hcd \
    kmod-usb-storage \
    kmod-usb-storage-uas \
    kmod-fb
  IMAGE/sysupgrade.img.gz := boot-common | amlogic-sdcard | gzip | append-metadata
endef
TARGET_DEVICES += oes_a311d_box  # 若修改设备名称，此处也需同步

# 内核预编译钩子：同步更新DTS路径
define Kernel/Prepare
    $(call Kernel/Prepare/Default)
    # 执行DTS复制脚本（脚本路径需与实际一致）
    sh /builder/openwrt/target/linux/amlogic/mesongx/files/dts-copy.sh
    # 验证新DTS文件是否存在
    if [ ! -f "$(LINUX_DIR)/arch/arm64/boot/dts/amlogic/meson-g12b-gtking-pro.dts" ]; then \
        echo "ERROR: 新DTS文件不存在！" >&2; \
        exit 1; \
    fi
endef

$(eval $(call BuildTarget))
    
