# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024 Your Name <your-email@example.com>

# 定义OES A311D设备的配置文件
define Profile/OES_A311D_BOX
  NAME:=OES Box (Amlogic A311D) 64-bit
  PACKAGES:=\
    kmod-amlogic-eth-g12b \
    kmod-usb3 \
    kmod-leds-gpio \
    kmod-wireguard \
    wpad-basic-mbedtls \
    luci \
    luci-app-webadmin \
    parted \
    resize2fs

  # 关联设备树（与mesongx/Makefile中的DEVICE_DTS一致）
  DEVICE_DTS:=meson-a311d-oes-box
  
  # 支持的设备标识（与DEVICE_VENDOR+DEVICE_MODEL呼应）
  SUPPORTED_DEVICES:=oes,a311d-box amlogic,a311d
endef

# 描述信息（显示在menuconfig中）
define Profile/OES_A311D_BOX/Description
  64-bit firmware for OES Box with Amlogic A311D SoC.
  Includes basic drivers, network tools, and Luci web interface.
endef

# 注册配置文件（确保仅在mesongx子目标下生效）
$(eval $(call Profile,OES_A311D_BOX))

# 设备安装后初始化脚本（可选，用于自动配置）
define Device/oes_a311d_box/install
	# 以下命令行必须用Tab缩进（修复核心语法错误）
	$(INSTALL_DIR) $(TARGET_DIR)/etc/init.d
	$(INSTALL_BIN) ./files/oes-a311d-init $(TARGET_DIR)/etc/init.d/oes-a311d-init
	$(LN) ../init.d/oes-a311d-init $(TARGET_DIR)/etc/rc.d/S99oes-a311d-init
endef