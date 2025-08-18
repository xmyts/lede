
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

DEVICE_VARS += UBOOT_DEVICE_NAME

FAT32_BLOCK_SIZE=1024
FAT32_BLOCKS=$(shell echo $$(($(CONFIG_TARGET_KERNEL_PARTSIZE)*1024*1024/$(FAT32_BLOCK_SIZE))))

# 新增：定义DTS源文件和目标路径（针对meson-a311d-oes-box）
DTS_A311D_OES_BOX_SOURCE := $(TOPDIR)/target/linux/amlogic/mesongx/dts/meson-a311d-oes-box.dts
DTS_A311D_OES_BOX_TARGET := $(LINUX_DIR)/arch/arm64/boot/dts/amlogic/meson-a311d-oes-box.dts

# 新增：强制复制DTS文件到内核目录（在设备树编译前执行）
$(DTS_A311D_OES_BOX_TARGET):
	@echo "=== 开始复制meson-a311d-oes-box.dts ==="
	# 检查源文件是否存在
	if [ ! -f "$(DTS_A311D_OES_BOX_SOURCE)" ]; then \
		echo "ERROR: 源DTS文件不存在！路径：$(DTS_A311D_OES_BOX_SOURCE)" >&2; \
		exit 1; \
	fi
	# 创建目标目录（确保内核DTS目录存在）
	mkdir -p $(dir $(DTS_A311D_OES_BOX_TARGET))
	# 强制复制文件（-f覆盖旧文件，-v显示复制过程）
	cp -fv $(DTS_A311D_OES_BOX_SOURCE) $(DTS_A311D_OES_BOX_TARGET)
	# 验证复制结果
	if [ ! -f "$(DTS_A311D_OES_BOX_TARGET)" ]; then \
		echo "ERROR: DTS文件复制失败！目标路径：$(DTS_A311D_OES_BOX_TARGET)" >&2; \
		exit 1; \
	fi
	@echo "=== meson-a311d-oes-box.dts复制完成 ==="

define Build/boot-script
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "boot.scr" -d boot.txt  $(KDIR)/boot.scr
endef

define Build/emmc-common
	$(RM) -f $@.boot
	mkfs.fat -C $@.boot $(FAT32_BLOCKS)

	mkdir -p $(KDIR)/boot.fat

	$(CP) $(KDIR)/boot.scr $(KDIR)/boot.fat/boot.scr
	mcopy -i $@.boot $(KDIR)/boot.scr ::
	$(CP) $(IMAGE_KERNEL) $(KDIR)/boot.fat/uImage
	mcopy -i $@.boot $(KDIR)/boot.fat/uImage ::

	$(foreach dts,$(shell echo $(DEVICE_DTS)),$(CP) $(DTS_DIR)/$(dts).dtb $(KDIR)/boot.fat/dtb;)
	mcopy -i $@.boot $(KDIR)/boot.fat/dtb ::

	$(RM) -rf $(KDIR)/boot.fat

	./gen_aml_emmc_img.sh $@ $@.boot $(IMAGE_ROOTFS) \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $(CONFIG_TARGET_ROOTFS_PARTSIZE)
endef

define Build/boot-common
	rm -fR $@.boot
	mkdir -p $@.boot

	$(CP) $(KDIR)/image-$(firstword $(DEVICE_DTS)).dtb $@.boot/amlogic.dtb
	$(CP) $(IMAGE_KERNEL) $@.boot/kernel.img
	$(CP) "$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-u-boot-overlay.bin $@.boot/u-boot.emmc
endef

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

define Build/boot-combined-script
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d aml_autoscript.cmd $@.boot/aml_autoscript
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d emmc_autoscript.cmd $@.boot/emmc_autoscript
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d s905_autoscript.cmd $@.boot/s905_autoscript
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d $(if $(1),$(1),amlogic).bootscript $@.boot/boot.scr
endef

define Build/aml-img
	SIGNATURE="$(IMG_PART_SIGNATURE)" \
		./gen_amlogic_image.sh \
		$@ \
		64 $@.boot \
		256 $(IMAGE_ROOTFS) \
		2048
endef

include $(SUBTARGET).mk

# oes_a311d_box设备定义（依赖新增的DTS复制规则）
define Device/oes_a311d_box
  $(call Device/Amlogic)
  DEVICE_DTS := meson-a311d-oes-box
  # 强制依赖DTS复制目标，确保编译前文件已就位
  $(KDIR)/image-$(DEVICE_DTS).dtb: $(DTS_A311D_OES_BOX_TARGET)
  IMAGE/sysupgrade.img.gz := boot-common | amlogic-sdcard | gzip | append-metadata
endef
TARGET_DEVICES += oes_a311d_box

$(eval $(call BuildImage))
