# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024 Your Name <your-email@example.com>

# ����OES A311D�豸�������ļ�
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

  # �����豸������mesongx/Makefile�е�DEVICE_DTSһ�£�
  DEVICE_DTS:=meson-a311d-oes-box
  
  # ֧�ֵ��豸��ʶ����DEVICE_VENDOR+DEVICE_MODEL��Ӧ��
  SUPPORTED_DEVICES:=oes,a311d-box amlogic,a311d
endef

# ������Ϣ����ʾ��menuconfig�У�
define Profile/OES_A311D_BOX/Description
  64-bit firmware for OES Box with Amlogic A311D SoC.
  Includes basic drivers, network tools, and Luci web interface.
endef

# ע�������ļ���ȷ������mesongx��Ŀ������Ч��
$(eval $(call Profile,OES_A311D_BOX))

# �豸��װ���ʼ���ű�����ѡ�������Զ����ã�
define Device/oes_a311d_box/install
	# ���������б�����Tab�������޸������﷨����
	$(INSTALL_DIR) $(TARGET_DIR)/etc/init.d
	$(INSTALL_BIN) ./files/oes-a311d-init $(TARGET_DIR)/etc/init.d/oes-a311d-init
	$(LN) ../init.d/oes-a311d-init $(TARGET_DIR)/etc/rc.d/S99oes-a311d-init
endef