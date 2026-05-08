#!/bin/bash

# Apple 开发者证书导出脚本
# 用于配置 GitHub Actions 自动发布

echo "=========================================="
echo "Apple 开发者证书导出工具"
echo "=========================================="
echo ""
echo "证书身份: Apple Development: nocoder@aliyun.com (RW7LS26MSR)"
echo "导出密码: TempPass@2026!"
echo ""

# 设置导出路径
EXPORT_PATH="/tmp/apple_dev_cert.p12"
PASSWORD="TempPass@2026!"

echo "即将导出证书到: $EXPORT_PATH"
echo "注意: 系统会弹出 Keychain 访问授权对话框，请点击「允许」"
echo ""

# 执行导出
security export \
    -k ~/Library/Keychains/login.keychain-db \
    -t identities \
    -f pkcs12 \
    -o "$EXPORT_PATH" \
    -P "$PASSWORD"

if [ -f "$EXPORT_PATH" ]; then
    echo ""
    echo "✓ 证书导出成功！"
    echo ""

    # 显示证书信息
    echo "证书文件信息:"
    ls -la "$EXPORT_PATH"

    echo ""
    echo "Base64 编码内容 (用于 GitHub Secret BUILD_CERTIFICATE_BASE64):"
    echo ""

    # 输出 Base64
    base64 -i "$EXPORT_PATH"

    echo ""
    echo "=========================================="
    echo "下一步操作:"
    echo "=========================================="
    echo "1. 复制上面的 Base64 内容"
    echo "2. 访问: https://github.com/yue1132/mew-notch/settings/secrets/actions"
    echo "3. 点击「New repository secret」"
    echo "4. Name: BUILD_CERTIFICATE_BASE64"
    echo "5. Value: 粘贴 Base64 内容"
    echo "6. 点击「Add secret」"
    echo ""
    echo "7. 再次点击「New repository secret」"
    echo "8. Name: P12_PASSWORD"
    echo "9. Value: TempPass@2026!"
    echo "10. 点击「Add secret»"
    echo "=========================================="
else
    echo ""
    echo "✗ 导出失败"
    echo ""
    echo "可能原因:"
    echo "- 没有在授权对话框中点击「允许」"
    echo "- Keychain 权限设置"
    echo ""
    echo "请检查:"
    security find-identity -v -p codesigning
fi

# 清理临时文件
echo ""
read -p "是否清理临时证书文件? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -f "$EXPORT_PATH"
    echo "临时文件已清理"
fi