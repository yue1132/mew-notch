# 手动配置 GitHub Secrets 指南

## 已完成配置

✅ **GitHub Pages**: 已启用，使用 `sparkle-pages` 分支
✅ **Appcast 地址**: `https://yue1132.github.io/mew-notch/sparkle/appcast.xml`
✅ **SPARKLE_PRIVATE_KEY**: 已自动生成并配置
✅ **KEYCHAIN_PASSWORD**: 已自动生成并配置
✅ **Release Workflow**: 已更新使用 `sparkle-pages` 分支

## 需要手动配置的 Secrets

### 1. BUILD_CERTIFICATE_BASE64

**步骤 A: 导出 Apple 开发者证书**

1. 打开 **钥匙串访问** 应用（Keychain Access）
2. 在左侧选择「登录」钥匙串
3. 在搜索框输入 `Apple Development`
4. 找到证书：`Apple Development: nocoder@aliyun.com (RW7LS26MSR)`
5. 右键点击证书 → 选择「导出」
6. 选择保存位置（如桌面）
7. 设置文件名：`apple_dev_cert.p12`
8. 设置密码：`TempPass@2026!`
9. 点击「保存」

**注意**: 如果证书旁边有私钥（展开查看），需要导出包含私钥的身份（identity）。

**步骤 B: 转换为 Base64**

在终端执行：

```bash
# 将证书转换为 Base64
base64 -i ~/Desktop/apple_dev_cert.p12 | pbcopy

echo "Base64 内容已复制到剪贴板"
```

或者直接运行：

```bash
base64 -i ~/Desktop/apple_dev_cert.p12
```

复制输出的所有内容（包括换行符）。

**步骤 C: 上传到 GitHub**

1. 打开：https://github.com/yue1132/mew-notch/settings/secrets/actions
2. 点击「New repository secret」
3. **Name**: `BUILD_CERTIFICATE_BASE64`
4. **Value**: 粘贴 Base64 内容
5. 点击「Add secret」

### 2. P12_PASSWORD

1. 在同一页面点击「New repository secret」
2. **Name**: `P12_PASSWORD`
3. **Value**: `TempPass@2026!`
4. 点击「Add secret」

### 3. PAT (Personal Access Token)

**步骤 A: 创建 PAT**

1. 打开：https://github.com/settings/tokens
2. 点击「Generate new token (classic)」
3. 设置：
   - **Note**: `MewNotch Release Workflow`
   - **Expiration**: `No expiration` 或选择长期有效
   - **Scopes**: 勾选以下权限：
     - `repo` (Full control of private repositories)
     - `workflow` (Update GitHub Action workflows)
     - `write:packages` (Upload packages to GitHub Package Registry)
4. 点击「Generate token」
5. **立即复制 Token**（只显示一次）

**步骤 B: 上传到 GitHub**

1. 打开：https://github.com/yue1132/mew-notch/settings/secrets/actions
2. 点击「New repository secret」
3. **Name**: `PAT`
4. **Value**: 粘贴 Token
5. 点击「Add secret」

### 4. VT_API_KEY (可选 - VirusTotal扫描)

如果需要 VirusTotal 扫描功能：

1. 注册：https://www.virustotal.com/gui/join-us
2. 获取 API Key
3. 在 Secrets 中添加：
   - **Name**: `VT_API_KEY`
   - **Value**: 你的 VirusTotal API Key

## 验证配置

配置完成后，所有 Secrets 应如下：

| Secret | 状态 |
|--------|------|
| SPARKLE_PRIVATE_KEY | ✅ 已配置 |
| KEYCHAIN_PASSWORD | ✅ 已配置 |
| BUILD_CERTIFICATE_BASE64 | ⏳ 待配置 |
| P12_PASSWORD | ⏳ 待配置 |
| PAT | ⏳ 待配置 |
| VT_API_KEY | ⏳ 可选 |

## 测试自动发布

配置完成后，测试发布流程：

```bash
# 创建新版本 tag
git tag v2.3.2-test
git push origin v2.3.2-test

# GitHub Actions 将自动触发：
# 1. 构建应用
# 2. 创建 DMG
# 3. 签名并发布到 GitHub Releases
# 4. 更新 appcast.xml
```

查看构建状态：
https://github.com/yue1132/mew-notch/actions

## 清理本地证书文件

配置完成后，删除本地证书文件：

```bash
rm ~/Desktop/apple_dev_cert.p12
```

## 安全提醒

⚠️ **重要**:
- 证书文件和密码包含敏感信息
- 不要将证书文件提交到 Git
- 不要将密码分享给他人
- PAT Token 拥有仓库写入权限，请妥善保管

## 需要帮助？

如果遇到问题：
1. 查看 Actions 构建日志：https://github.com/yue1132/mew-notch/actions
2. 检查 Secrets 配置：https://github.com/yue1132/mew-notch/settings/secrets/actions
3. 确认证书导出时包含私钥（identity）

---

**配置完成后，自动更新功能将完全可用！**