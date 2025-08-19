#!/bin/sh

# 源DTS文件路径（更新为新文件名）
SRC_DTS="/builder/openwrt/target/linux/amlogic/mesongx/dts/meson-g12b-gtking-pro.dts"
# 目标路径（更新为新文件名）
DST_DTS="/builder/openwrt/build_dir/target-aarch64_cortex-a73.cortex-a53_musl/linux-amlogic_mesongx/linux-5.15.189/arch/arm64/boot/dts/amlogic/meson-g12b-gtking-pro.dts"

echo "=== 执行DTS复制（新文件名） ==="
echo "源文件: $SRC_DTS"
echo "目标文件: $DST_DTS"

# 检查源文件是否存在
if [ ! -f "$SRC_DTS" ]; then
    echo "ERROR: 新源DTS文件不存在！路径: $SRC_DTS" >&2
    exit 1
fi

# 创建目标目录并复制
mkdir -p $(dirname "$DST_DTS")
cp -fv "$SRC_DTS" "$DST_DTS"

# 验证复制结果
if [ ! -f "$DST_DTS" ]; then
    echo "ERROR: 新DTS文件复制失败！路径: $DST_DTS" >&2
    exit 1
fi

echo "=== 新DTS复制成功 ==="
    
