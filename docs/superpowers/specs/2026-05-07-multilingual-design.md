# MewNotch 多语言支持设计文档

**日期**: 2026-05-07
**状态**: 已批准
**实现方式**: 原生 SwiftUI String Catalog

---

## 需求概述

为 MewNotch 添加中英文多语言支持，用户可在设置页面手动切换语言。

**用户决策记录：**
- 语言切换方式：设置页面手动切换
- 翻译范围：全部 UI 文本
- 文件格式：String Catalog (.xcstrings)
- 默认语言：英文

---

## 架构设计

### 新增文件

| 文件路径 | 用途 |
|---------|------|
| `MewNotch/Resources/Localizable.xcstrings` | String Catalog 翻译文件 |
| `MewNotch/DB/UserDefaults/App/LanguageDefaults.swift` | 语言偏好存储 |
| `MewNotch/ViewModel/LanguageManager.swift` | 语言切换管理器 |

### 修改文件

- `GeneraSettingsView.swift` — 添加语言切换设置项
- `MewNotchApp.swift` — 应用 locale environment
- 所有 View 文件 — 替换硬编码文本为 LocalizedStringResource

---

## 数据流

```
用户切换语言
→ LanguageManager 更新 LanguageDefaults.languageCode
→ 发布 locale 变化
→ SwiftUI environment(\.locale) 刷新
→ Text(LocalizedStringResource) 加载对应翻译
```

---

## UserDefaults 存储设计

使用现有 PropertyWrapper 模式：

```swift
final class LanguageDefaults: ObservableObject {
    static let shared = LanguageDefaults()

    @PrimitiveUserDefault("app_language", defaultValue: "en")
    var languageCode: String

    var currentLocale: Locale {
        Locale(identifier: languageCode)
    }
}
```

---

## 语言切换 UI

在 `GeneraSettingsView` 的 "App" Section 添加语言选择器：

```swift
SettingsRow(
    title: "Language",
    subtitle: "Choose display language",
    icon: MewNotch.Assets.icLanguage,
    color: MewNotch.Colors.language
) {
    Picker("", selection: $languageDefaults.languageCode) {
        Text("English").tag("en")
        Text("中文").tag("zh-CN")
    }
}
```

---

## 翻译内容规划

String Catalog 关键 key：

| Key | English | 中文 |
|-----|---------|------|
| `general` | General | 通用 |
| `notch` | Notch | 凹口 |
| `notch_items` | Notch Items | 凹口项 |
| `collapsed` | Collapsed | 折叠 |
| `expanded` | Expanded | 展开 |
| `about` | About | 关于 |
| `launch_at_login` | Launch at Login | 登录时启动 |
| `launch_at_login_subtitle` | Automatically start MewNotch when you log in | 登录时自动启动 MewNotch |
| `status_icon` | Status Icon | 状态图标 |
| `status_icon_subtitle` | Show icon in menu bar for easy access | 在菜单栏显示图标便于访问 |
| `language` | Language | 语言 |
| `language_subtitle` | Choose display language | 选择显示语言 |
| `disable_system_hud` | Disable System HUD | 禁用系统 HUD |
| `disable_system_hud_subtitle` | Hide system volume and brightness overlays | 隐藏系统音量和亮度覆盖层 |
| `accessibility_required` | Accessibility permissions are required. | 需要辅助功能权限 |
| `open_system_settings` | Open System Settings | 打开系统设置 |
| `show_notch_on` | Show Notch On | 凹口显示位置 |
| `choose_display` | Choose Displays to show notch on | 选择显示凹口的显示器 |
| `show_on_lock_screen` | Show on Lock Screen | 在锁屏显示 |
| `show_on_lock_screen_subtitle` | Incompatible with File Shelf feature | 与文件架功能不兼容 |
| `hide_on_full_screen` | Hide on Full Screen | 全屏时隐藏 |
| `hide_on_full_screen_subtitle` | Hides the notch when a full screen app is detected | 检测到全屏应用时隐藏凹口 |
| `reset_view_on_collapse` | Reset View on Collapse | 折叠时重置视图 |
| `reset_view_on_collapse_subtitle_true` | Notch resets to Home when Collapsed | 折叠时凹口重置到主页 |
| `reset_view_on_collapse_subtitle_false` | Notch will retain state when Collapsed | 折叠时凹口保持状态 |
| `height` | Height | 高度 |
| `apply_glass_effect` | Apply Glass Effect | 应用玻璃效果 |
| `apply_glass_effect_subtitle` | Forces 'Expand on Hover' to be enabled | 强制启用悬停展开 |
| `expand_on_hover` | Expand on Hover | 悬停展开 |
| `expand_on_hover_subtitle` | Expand notch when hovered.\nDisables click interactions in all HUDs. | 悬停时展开凹口。\n禁用所有 HUD 的点击交互。 |
| `hover_delay` | Hover Delay | 悬停延迟 |
| `hover_delay_subtitle` | seconds. | 秒 |
| `haptic_feedback` | Haptic Feedback | 触觉反馈 |
| `haptic_feedback_subtitle` | Play haptic feedback when hovering over the notch | 悬停凹口时播放触觉反馈 |
| `displays` | Displays | 显示器 |
| `interface` | Interface | 界面 |
| `interaction` | Interaction | 交互 |
| `left` | Left | 剩余 |
| `drop_files_here` | Drop Files Here | 拖放文件至此 |
| `airdrop` | AirDrop | AirDrop |
| `mirror` | Mirror | 镜像 |
| `tap_to_allow_camera` | Tap to Allow Camera | 点击允许摄像头 |
| `camera_access_required` | Camera Access Required | 需要摄像头访问权限 |
| `now_playing` | Now Playing | 正在播放 |
| `check_for_updates` | Check for Updates | 检查更新 |
| `view_on_github` | View on GitHub | 在 GitHub 查看 |
| `version` | Version | 版本 |

---

## 实现步骤

1. 创建 `Localizable.xcstrings` String Catalog 文件
2. 创建 `LanguageDefaults.swift` 和 `LanguageManager.swift`
3. 修改 `MewNotchApp.swift` 应用 locale environment
4. 修改 `GeneraSettingsView.swift` 添加语言切换 UI
5. 批量替换所有 View 中的硬编码文本
6. 测试语言切换功能

---

## 注意事项

- 保持英文作为 default/fallback 语言
- String Catalog key 使用 snake_case 格式
- 动态内容（如时间显示）不需翻译
- 需要添加语言图标资源 `icLanguage`