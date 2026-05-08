# GitHub Secrets 配置指南

## ✅ 所有配置已完成

| Secret | 状态 | 配置时间 |
|--------|------|----------|
| `SPARKLE_PRIVATE_KEY` | ✅ 已配置 | 2026-05-08 14:48 |
| `KEYCHAIN_PASSWORD` | ✅ 已配置 | 2026-05-08 14:48 |
| `BUILD_CERTIFICATE_BASE64` | ✅ 已配置 | 2026-05-08 15:35 |
| `P12_PASSWORD` | ✅ 已配置 | 2026-05-08 15:35 |
| `PAT` | ✅ 已配置 | 2026-05-08 15:35 |

## 已完成基础设施

✅ **GitHub Pages**: 已启用，使用 `sparkle-pages` 分支
✅ **Appcast 地址**: `https://yue1132.github.io/mew-notch/sparkle/appcast.xml`
✅ **Release Workflow**: 已更新使用 `sparkle-pages` 分支
✅ **Apple 证书**: 已导出并配置到 GitHub Secrets

---

## 发布流程

当在 GitHub 创建 Release 时，Actions 自动执行：
1. 构建 MewNotch.app
2. 使用 Apple 证书签名
3. 创建 DMG 安装包
4. 生成 Sparkle Appcast（带 ED25519 签名）
5. 上传到 GitHub Releases
6. 更新 GitHub Pages 的 appcast.xml

用户通过 App 内的 Sparkle 检查更新功能自动获取新版本。

---

## 测试发布

创建新版本 Release：
```bash
# 1. 更新版本号
#    - MewNotch/Info.plist: CFBundleShortVersionString, CFBundleVersion
#    - MewNotch.xcodeproj/project.pbxproj

# 2. 提交更改
git add .
git commit -m "release: v2.3.2"

# 3. 创建 GitHub Release
gh release create v2.3.2 --title "Version 2.3.2" --notes "Bug fixes"
```

查看构建状态：https://github.com/yue1132/mew-notch/actions

---

## Appcast 签名验证

Sparkle 使用 ED25519 签名验证更新包安全性：
- 私钥：存储在 GitHub Secrets (`SPARKLE_PRIVATE_KEY`)
- 公钥：嵌入 Info.plist (`SUPublicEDKey`)
- 签名：写入 appcast.xml 的 `sparkle:edSignature` 属性

---

## 安全注意事项

⚠️ **已完成安全措施**:
- 临时证书文件已清理 (`/tmp/apple_dev_cert.p12`)
- Secrets 通过 GitHub 加密存储
- PAT Token 使用 gh CLI 认证的有限权限 token

---

**自动更新系统已完全就绪！**