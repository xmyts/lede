#!/bin/sh
# 内核编译前执行的DTS复制脚本

# 源DTS文件路径（绝对路径，根据实际环境调整）
SRC_DTS="/builder/openwrt/target/linux/amlogic/mesongx/dts/meson-a311d-oes-box.dts"
# 目标路径（内核DTS目录）
DST_DTS="/builder/openwrt/build_dir/target-aarch64_cortex-a73.cortex-a53_musl/linux-amlogic_mesongx/linux-5.15.189/arch/arm64/boot/dts/amlogic/meson-a311d-oes-box.dts"

echo "=== 执行内核预编译DTS复制 ==="
echo "源文件: $SRC_DTS"
echo "目标文件: $DST_DTS"

# 检查源文件是否存在
if [ ! -f "$SRC_DTS" ]; then
    echo "ERROR: 源DTS文件不存在！请确认路径是否正确: $SRC_DTS" >&2
    exit 1
fi

# 创建目标目录
mkdir -p $(dirname "$DST_DTS")

# 强制复制并保留权限
cp -fv "$SRC_DTS" "$DST_DTS"

# 再次检查目标文件是否存在
if [ ! -f "$DST_DTS" ]; then
    echo "ERROR: DTS文件复制失败！目标路径可能无权限: $DST_DTS" >&2
    exit 1
fi

echo "=== DTS复制成功 ==="
    