# 自动更新功能配置指南

## 已完成配置

### 1. 更新地址配置

所有自动更新地址已更新到当前仓库：

| 配置项 | 地址 |
|--------|------|
| Appcast URL | `https://yue1132.github.io/mew-notch/sparkle/appcast.xml` |
| DMG 下载地址 | `https://github.com/yue1132/mew-notch/releases/download/v{version}/MewNotch-{version}.dmg` |

### 2. GitHub Actions 自动发布

`.github/workflows/release.yml` 已配置：
- 自动构建 DMG 安装包
- 自动签名生成 Sparkle 签名
- 自动更新 appcast.xml 到 gh-pages 分支

## 需要手动配置

### 启用 GitHub Pages

**步骤**：

1. 打开 GitHub 仓库设置页面：
   ```
   https://github.com/yue1132/mew-notch/settings/pages
   ```

2. 在 **Build and deployment** 部分：
   - **Source**: 选择 `Deploy from a branch`
   - **Branch**: 选择 `gh-page` 分支
   - **Folder**: 选择 `/(root)` 或 `/public`

3. 点击 **Save**

4. 等待几分钟，GitHub Pages 会自动部署

5. 验证部署成功：
   ```bash
   curl https://yue1132.github.io/mew-notch/sparkle/appcast.xml
   ```
   应返回 XML 内容

### 配置 GitHub Secrets

GitHub Actions 需要以下 Secrets 才能正常工作：

访问：`https://github.com/yue1132/mew-notch/settings/secrets/actions`

**必需 Secrets**：

| Secret 名称 | 说明 |
|-------------|------|
| `BUILD_CERTIFICATE_BASE64` | Apple 开发者证书（P12 格式，Base64 编码） |
| `P12_PASSWORD` | P12 证书密码 |
| `KEYCHAIN_PASSWORD` |临时钥匙串密码 |
| `SPARKLE_PRIVATE_KEY` | Sparkle ED25519 私钥（用于签名 DMG） |
| `PAT` | GitHub Personal Access Token（用于推送 gh-pages） |

**可选 Secrets**：

| Secret 名称 | 说明 |
|-------------|------|
| `VT_API_KEY` | VirusTotal API 密钥（用于病毒扫描） |

#### 生成 Sparkle 密钥

如果还没有 Sparkle 密钥，可以生成：

```bash
# 生成私钥
openssl genpkey -algorithm ED25519 -out sparkle_private_key.pem

# 提取公钥
openssl pkey -in sparkle_private_key.pem -pubout -out sparkle_public_key.pem

# 获取公钥（用于 Info.plist）
cat sparkle_public_key.pem | grep -v "PUBLIC KEY" | tr -d '\n'

# 获取私钥（用于 GitHub Secrets）
cat sparkle_private_key.pem | base64
```

更新 Info.plist 的公钥：
```xml
<key>SUPublicEDKey</key>
<string>{你的公钥}</string>
```

## 测试自动更新

### 1. 创建新版本发布

```bash
# 更新版本号（如 2.3.2）
# 修改 CHANGELOG.md

# 提交并打 tag
git tag v2.3.2
git push origin v2.3.2
```

### 2. GitHub Actions 自动执行

当推送 tag 后，GitHub Actions 会：
1. 构建应用并签名
2. 创建 DMG 安装包
3. 生成 appcast.xml
4. 上传到 GitHub Releases
5. 推送 appcast.xml 到 gh-pages 分支

### 3. 用户检查更新

用户在应用中：
- 打开设置 → 关于
- 点击"检查更新"
- Sparkle 自动下载并安装新版本

## 当前状态

✅ Info.plist 配置已更新
✅ appcast.xml 配置已更新
✅ GitHub Actions workflow 配置正确
⚠️ GitHub Pages 需要手动启用
⚠️ GitHub Secrets 需要手动配置

## 下一步

1. 启用 GitHub Pages (`gh-page` 分支)
2. 配置 GitHub Secrets（证书和密钥）
3. 创建测试发布验证流程

---

**更新日期**: 2026-05-08