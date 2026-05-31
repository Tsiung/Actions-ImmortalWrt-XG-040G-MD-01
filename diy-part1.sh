#!/bin/bash
PATCHES_DIR="$GITHUB_WORKSPACE/patches"
USER_BRANCH="$1"   # 例如 master-XG-040G-MD 或 openwrt-25.12-XG-040G-MD

echo "用户选择分支: $USER_BRANCH"

if [ "$USER_BRANCH" = "master-XG-040G-MD" ]; then
    PATCH_FILE="$PATCHES_DIR/airoha-en7581-support-master-fzs209-260531.patch"
elif [ "$USER_BRANCH" = "openwrt-25.12-XG-040G-MD" ]; then
    PATCH_FILE="$PATCHES_DIR/airoha-en7581-support-25.12-fzs209-260531.patch"
else
    echo "未知分支，跳过补丁"
    exit 0
fi

if [ -f "$PATCH_FILE" ]; then
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
