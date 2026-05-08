#!/bin/bash

# MewNotch 发布脚本
# 用于构建、签名和生成 Sparkle appcast

set -e

# 配置
PROJECT_NAME="MewNotch"
PROJECT_PATH="MewNotch.xcodeproj"
SCHEME="MewNotch"
OUTPUT_DIR="./release"
SPARKLE_DIR="./sparkle"

# 版本号从项目配置读取
MARKETING_VERSION=$(grep -m1 "MARKETING_VERSION" MewNotch.xcodeproj/project.pbxproj | cut -d'=' -f2 | tr -d ' ')
BUILD_VERSION=$(grep -m1 "CURRENT_PROJECT_VERSION" MewNotch.xcodeproj/project.pbxproj | cut -d'=' -f2 | tr -d ' ')

echo "========================================"
echo "MewNotch 发布脚本"
echo "========================================"
echo "版本: $MARKETING_VERSION"
echo "构建号: $BUILD_VERSION"
echo "========================================"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 清理之前的构建
echo "清理之前的构建..."
rm -rf "$OUTPUT_DIR/$PROJECT_NAME.app"
rm -rf "$OUTPUT_DIR/$PROJECT_NAME-$MARKETING_VERSION.zip"

# 构建项目
echo "构建项目..."
xcodebuild -project "$PROJECT_PATH" \
    -scheme "$SCHEME" \
    -configuration Release \
    -destination "platform=macOS" \
    clean build \
    ARCHIVE_PATH="$OUTPUT_DIR/$PROJECT_NAME.xcarchive"

# 从 xcarchive 中提取 app
echo "提取应用包..."
cp -r "$OUTPUT_DIR/$PROJECT_NAME.xcarchive/Products/Applications/$PROJECT_NAME.app" "$OUTPUT_DIR/"

# 签名应用（如果需要）
echo "检查应用签名..."
codesign -dv "$OUTPUT_DIR/$PROJECT_NAME.app" || true

# 创建 zip 包
echo "创建发布包..."
cd "$OUTPUT_DIR"
ditto -c -k --keepParent "$PROJECT_NAME.app" "$PROJECT_NAME-$MARKETING_VERSION.zip"
cd ..

# 使用 Sparkle 工具生成签名（需要安装 Sparkle）
if command -v sign_update &> /dev/null; then
    echo "生成 Sparkle 签名..."
    SIGNATURE=$(sign_update "$OUTPUT_DIR/$PROJECT_NAME-$MARKETING_VERSION.zip")
    echo "签名: $SIGNATURE"
else
    echo "警告: sign_update 工具未安装，跳过签名生成"
    echo "请从 https://github.com/sparkle-project/Sparkle/releases 下载 Sparkle 工具"
fi

# 计算 zip 文件大小
ZIP_SIZE=$(stat -f%z "$OUTPUT_DIR/$PROJECT_NAME-$MARKETING_VERSION.zip")
echo "包大小: $ZIP_SIZE bytes"

# 更新 appcast.xml
echo "更新 appcast.xml..."
python3 ./scripts/update_appcast.py \
    --version "$MARKETING_VERSION" \
    --build "$BUILD_VERSION" \
    --size "$ZIP_SIZE" \
    --signature "$SIGNATURE" \
    --url "https://github.com/monuk7735/mew-notch/releases/download/v$MARKETING_VERSION/$PROJECT_NAME-$MARKETING_VERSION.zip"

echo "========================================"
echo "发布完成！"
echo "========================================"
echo "应用包: $OUTPUT_DIR/$PROJECT_NAME-$MARKETING_VERSION.zip"
echo "appcast.xml: $SPARKLE_DIR/appcast.xml"
echo ""
echo "下一步："
echo "1. 将 zip 文件上传到 GitHub Releases"
echo "2. 将更新后的 appcast.xml 推送到 GitHub Pages"
echo "========================================"