#!/bin/bash
PATCHES_DIR="$GITHUB_WORKSPACE/patches"
USER_BRANCH="$1"

echo "用户选择分支: $USER_BRANCH"

# 1. 根据分支选择补丁文件
if [ "$USER_BRANCH" = "master-XG-040G-MD" ]; then
    PATCH_FILE="$PATCHES_DIR/airoha-en7581-support-master.patch"
elif [ "$USER_BRANCH" = "openwrt-25.12-XG-040G-MD" ]; then
    PATCH_FILE="$PATCHES_DIR/airoha-en7581-support-25.12.patch"
else
    echo "未知分支，跳过补丁"
    exit 0
fi

# 2. 添加 OpenClash feed（如果尚未添加）
FEEDS_CONF="feeds.conf.default"
if [ ! -f "$FEEDS_CONF" ]; then
    touch "$FEEDS_CONF"
fi
if ! grep -q "openclash" "$FEEDS_CONF"; then
    echo "src-git openclash https://github.com/vernesong/OpenClash.git" >> "$FEEDS_CONF"
    echo "OpenClash feed added."
fi

# 3. 应用设备补丁
if [ -f "$PATCH_FILE" ]; then
# 创建补丁中需要的文件（避免 patch 失败）
    touch xg-040g-md.config
    echo "正在应用补丁: $PATCH_FILE"
    patch -p1 < "$PATCH_FILE"
    if [ $? -eq 0 ]; then
        echo "补丁应用成功"
    else
        echo "补丁应用失败！"
        exit 1
    fi
else
    echo "错误: 找不到补丁文件 $PATCH_FILE"
    exit 1
fi
