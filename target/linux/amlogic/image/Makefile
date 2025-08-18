
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

# 设备变量（用于U-Boot文件引用）
DEVICE_VARS += UBOOT_DEVICE_NAME

# FAT32分区配置（根据内核分区大小计算）
FAT32_BLOCK_SIZE=1024
FAT32_BLOCKS=$(shell echo $$(($(CONFIG_TARGET_KERNEL_PARTSIZE)*1024*1024/$(FAT32_BLOCK_SIZE))))

# 生成U-Boot启动脚本镜像
define Build/boot-script
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "boot.scr" -d boot.txt $(KDIR)/boot.scr
endef

# eMMC镜像通用规则（分区构建）
define Build/emmc-common
	$(RM) -f $@.boot
	mkfs.fat -C $@.boot $(FAT32_BLOCKS)

	mkdir -p $(KDIR)/boot.fat
	$(CP) $(KDIR)/boot.scr $(KDIR)/boot.fat/boot.scr
	mcopy -i $@.boot $(KDIR)/boot.scr ::
	$(CP) $(IMAGE_KERNEL) $(KDIR)/boot.fat/uImage
	mcopy -i $@.boot $(KDIR)/boot.fat/uImage ::

	# 复制设备树文件到boot分区
	$(foreach dts,$(shell echo $(DEVICE_DTS)),$(CP) $(DTS_DIR)/$(dts).dtb $(KDIR)/boot.fat/dtb;)
	mcopy -i $@.boot $(KDIR)/boot.fat/dtb ::

	$(RM) -rf $(KDIR)/boot.fat

	# 生成eMMC镜像（调用外部脚本）
	./gen_aml_emmc_img.sh $@ $@.boot $(IMAGE_ROOTFS) \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $(CONFIG_TARGET_ROOTFS_PARTSIZE)
endef

# 通用boot分区构建（复制DTB、内核、U-Boot文件）
define Build/boot-common
	rm -fR $@.boot
	mkdir -p $@.boot

	# 复制设备树二进制文件（DTB）到boot分区（命名为amlogic.dtb，供U-Boot加载）
	$(CP) $(KDIR)/image-$(firstword $(DEVICE_DTS)).dtb $@.boot/amlogic.dtb
	# 复制内核镜像到boot分区
	$(CP) $(IMAGE_KERNEL) $@.boot/kernel.img
	# 复制U-Boot文件到boot分区（依赖UBOOT_DEVICE_NAME变量）
	$(CP) "$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-u-boot-overlay.bin $@.boot/u-boot.emmc
endef

# 多设备树boot分区构建（当前设备无需，保留通用规则）
define Build/boot-combined
	rm -fR $@.boot
	mkdir -p $@.boot

	i=0; \
	for dts in $(DEVICE_DTS); do \
		$(CP) $(KDIR)/image-$${dts}.dtb $@.boot/amlogic$$(perl -e 'printf "%b\n",'$$i).dtb; \
		let i+=1; \
	done
	$(CP) $(IMAGE_KERNEL) $@.boot/kernel.img
	$(CP) "$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-u-boot-overlay.bin $@.boot/u-boot.emmc
endef

# 生成U-Boot自动启动脚本
define Build/boot-combined-script
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d aml_autoscript.cmd $@.boot/aml_autoscript
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d emmc_autoscript.cmd $@.boot/emmc_autoscript
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d s905_autoscript.cmd $@.boot/s905_autoscript
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d $(if $(1),$(1),amlogic).bootscript $@.boot/boot.scr
endef

# 生成SD/USB镜像（整合boot和root分区）
define Build/aml-img
	SIGNATURE="$(IMG_PART_SIGNATURE)" \
		./gen_amlogic_image.sh \
		$@ \
		64 $@.boot \
		256 $(IMAGE_ROOTFS) \
		2048
endef

# 引入子目标定义（保留原有平台规则）
include $(SUBTARGET).mk

# oes_a311d_box设备镜像规则（补充UBOOT_DEVICE_NAME）
define Device/oes_a311d_box
  $(call Device/Amlogic)  # 继承Amlogic平台通用配置
  DEVICE_DTS := meson-a311d-oes-box  # 匹配DTS文件名
  UBOOT_DEVICE_NAME := meson-a311d-oes-box  # 匹配U-Boot文件名（避免文件缺失）
  # 镜像生成流程（与Makefile中的定义对应）
  IMAGE/sysupgrade.img.gz := boot-common | amlogic-sdcard | gzip | append-metadata
endef
TARGET_DEVICES += oes_a311d_box

# 声明镜像构建目标
$(eval $(call BuildImage))
