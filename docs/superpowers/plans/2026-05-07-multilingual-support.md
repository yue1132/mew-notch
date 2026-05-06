# MewNotch 多语言支持实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为 MewNotch 添加中英文多语言支持，用户可在设置页面手动切换

**Architecture:** 使用原生 SwiftUI String Catalog 方案，通过 LanguageDefaults 存储用户语言偏好，LanguageManager 管理语言切换，environment(\.locale) 动态刷新所有视图

**Tech Stack:** SwiftUI String Catalog (.xcstrings), UserDefaults PropertyWrapper, Locale environment

---

## 文件结构

**新增文件：**
- `MewNotch/Resources/Localizable.xcstrings` — String Catalog 翻译文件
- `MewNotch/DB/UserDefaults/App/LanguageDefaults.swift` — 语言偏好存储
- `MewNotch/ViewModel/LanguageManager.swift` — 语言切换管理器

**修改文件：**
- `MewNotch/MewNotchApp.swift` — 应用 locale environment
- `MewNotch/View/Settings/Pages/GeneraSettingsView.swift` — 添加语言切换设置项
- `MewNotch/Resources/MewNotch.swift` — 添加语言图标和颜色
- `MewNotch/View/Settings/MewSettingsView.swift` — 替换侧边栏硬编码文本
- `MewNotch/View/Settings/Pages/NotchSettingsView.swift` — 替换设置项文本
- `MewNotch/View/Settings/Pages/AboutAppView.swift` — 替换关于页面文本
- `MewNotch/View/Notch/Expanded/ParentViews/FileShelfView.swift` — 替换文件架文本
- `MewNotch/View/Notch/Expanded/ItemViews/MirrorView.swift` — 替换镜像视图文本
- `MewNotch/View/Notch/Collapsed/HUDView/NowPlayingTextHUDView.swift` — 替换正在播放文本
- `MewNotch/View/Notch/Collapsed/HUDView/PowerHUDView.swift` — 替换电源 HUD 文本

---

### Task 1: 创建 String Catalog 文件

**Files:**
- Create: `MewNotch/Resources/Localizable.xcstrings`

- [ ] **Step 1: 创建 Localizable.xcstrings 文件**

String Catalog 是 JSON 格式，包含英文和中文翻译：

```json
{
  "sourceLanguage" : "en",
  "strings" : {
    "general" : {
      "localizations" : {
        "en" : "General",
        "zh-CN" : "通用"
      }
    },
    "notch" : {
      "localizations" : {
        "en" : "Notch",
        "zh-CN" : "凹口"
      }
    },
    "notch_items" : {
      "localizations" : {
        "en" : "Notch Items",
        "zh-CN" : "凹口项"
      }
    },
    "collapsed" : {
      "localizations" : {
        "en" : "Collapsed",
        "zh-CN" : "折叠"
      }
    },
    "expanded" : {
      "localizations" : {
        "en" : "Expanded",
        "zh-CN" : "展开"
      }
    },
    "about" : {
      "localizations" : {
        "en" : "About",
        "zh-CN" : "关于"
      }
    },
    "app" : {
      "localizations" : {
        "en" : "App",
        "zh-CN" : "应用"
      }
    },
    "system" : {
      "localizations" : {
        "en" : "System",
        "zh-CN" : "系统"
      }
    },
    "displays" : {
      "localizations" : {
        "en" : "Displays",
        "zh-CN" : "显示器"
      }
    },
    "interface" : {
      "localizations" : {
        "en" : "Interface",
        "zh-CN" : "界面"
      }
    },
    "interaction" : {
      "localizations" : {
        "en" : "Interaction",
        "zh-CN" : "交互"
      }
    },
    "launch_at_login" : {
      "localizations" : {
        "en" : "Launch at Login",
        "zh-CN" : "登录时启动"
      }
    },
    "launch_at_login_subtitle" : {
      "localizations" : {
        "en" : "Automatically start MewNotch when you log in",
        "zh-CN" : "登录时自动启动 MewNotch"
      }
    },
    "status_icon" : {
      "localizations" : {
        "en" : "Status Icon",
        "zh-CN" : "状态图标"
      }
    },
    "status_icon_subtitle" : {
      "localizations" : {
        "en" : "Show icon in menu bar for easy access",
        "zh-CN" : "在菜单栏显示图标便于访问"
      }
    },
    "language" : {
      "localizations" : {
        "en" : "Language",
        "zh-CN" : "语言"
      }
    },
    "language_subtitle" : {
      "localizations" : {
        "en" : "Choose display language",
        "zh-CN" : "选择显示语言"
      }
    },
    "english" : {
      "localizations" : {
        "en" : "English",
        "zh-CN" : "英文"
      }
    },
    "chinese" : {
      "localizations" : {
        "en" : "中文",
        "zh-CN" : "中文"
      }
    },
    "disable_system_hud" : {
      "localizations" : {
        "en" : "Disable System HUD",
        "zh-CN" : "禁用系统 HUD"
      }
    },
    "disable_system_hud_subtitle" : {
      "localizations" : {
        "en" : "Hide system volume and brightness overlays",
        "zh-CN" : "隐藏系统音量和亮度覆盖层"
      }
    },
    "accessibility_required" : {
      "localizations" : {
        "en" : "Accessibility permissions are required.",
        "zh-CN" : "需要辅助功能权限。"
      }
    },
    "open_system_settings" : {
      "localizations" : {
        "en" : "Open System Settings",
        "zh-CN" : "打开系统设置"
      }
    },
    "show_notch_on" : {
      "localizations" : {
        "en" : "Show Notch On",
        "zh-CN" : "凹口显示位置"
      }
    },
    "choose_display" : {
      "localizations" : {
        "en" : "Choose Displays to show notch on",
        "zh-CN" : "选择显示凹口的显示器"
      }
    },
    "show_on_lock_screen" : {
      "localizations" : {
        "en" : "Show on Lock Screen",
        "zh-CN" : "在锁屏显示"
      }
    },
    "show_on_lock_screen_subtitle" : {
      "localizations" : {
        "en" : "Incompatible with File Shelf feature",
        "zh-CN" : "与文件架功能不兼容"
      }
    },
    "hide_on_full_screen" : {
      "localizations" : {
        "en" : "Hide on Full Screen",
        "zh-CN" : "全屏时隐藏"
      }
    },
    "hide_on_full_screen_subtitle" : {
      "localizations" : {
        "en" : "Hides the notch when a full screen app is detected",
        "zh-CN" : "检测到全屏应用时隐藏凹口"
      }
    },
    "reset_view_on_collapse" : {
      "localizations" : {
        "en" : "Reset View on Collapse",
        "zh-CN" : "折叠时重置视图"
      }
    },
    "reset_view_on_collapse_subtitle_true" : {
      "localizations" : {
        "en" : "Notch resets to Home when Collapsed",
        "zh-CN" : "折叠时凹口重置到主页"
      }
    },
    "reset_view_on_collapse_subtitle_false" : {
      "localizations" : {
        "en" : "Notch will retain state when Collapsed",
        "zh-CN" : "折叠时凹口保持状态"
      }
    },
    "height" : {
      "localizations" : {
        "en" : "Height",
        "zh-CN" : "高度"
      }
    },
    "apply_glass_effect" : {
      "localizations" : {
        "en" : "Apply Glass Effect",
        "zh-CN" : "应用玻璃效果"
      }
    },
    "apply_glass_effect_subtitle" : {
      "localizations" : {
        "en" : "Forces 'Expand on Hover' to be enabled",
        "zh-CN" : "强制启用悬停展开"
      }
    },
    "expand_on_hover" : {
      "localizations" : {
        "en" : "Expand on Hover",
        "zh-CN" : "悬停展开"
      }
    },
    "expand_on_hover_subtitle" : {
      "localizations" : {
        "en" : "Expand notch when hovered.\nDisables click interactions in all HUDs.",
        "zh-CN" : "悬停时展开凹口。\n禁用所有 HUD 的点击交互。"
      }
    },
    "hover_delay" : {
      "localizations" : {
        "en" : "Hover Delay",
        "zh-CN" : "悬停延迟"
      }
    },
    "hover_delay_subtitle" : {
      "localizations" : {
        "en" : "seconds.",
        "zh-CN" : "秒。"
      }
    },
    "haptic_feedback" : {
      "localizations" : {
        "en" : "Haptic Feedback",
        "zh-CN" : "触觉反馈"
      }
    },
    "haptic_feedback_subtitle" : {
      "localizations" : {
        "en" : "Play haptic feedback when hovering over the notch",
        "zh-CN" : "悬停凹口时播放触觉反馈"
      }
    },
    "left" : {
      "localizations" : {
        "en" : "Left",
        "zh-CN" : "剩余"
      }
    },
    "drop_files_here" : {
      "localizations" : {
        "en" : "Drop Files Here",
        "zh-CN" : "拖放文件至此"
      }
    },
    "airdrop" : {
      "localizations" : {
        "en" : "AirDrop",
        "zh-CN" : "AirDrop"
      }
    },
    "mirror" : {
      "localizations" : {
        "en" : "Mirror",
        "zh-CN" : "镜像"
      }
    },
    "tap_to_allow_camera" : {
      "localizations" : {
        "en" : "Tap to Allow Camera",
        "zh-CN" : "点击允许摄像头"
      }
    },
    "camera_access_required" : {
      "localizations" : {
        "en" : "Camera Access Required",
        "zh-CN" : "需要摄像头访问权限"
      }
    },
    "now_playing" : {
      "localizations" : {
        "en" : "Now Playing",
        "zh-CN" : "正在播放"
      }
    },
    "check_for_updates" : {
      "localizations" : {
        "en" : "Check for Updates",
        "zh-CN" : "检查更新"
      }
    },
    "view_on_github" : {
      "localizations" : {
        "en" : "View on GitHub",
        "zh-CN" : "在 GitHub 查看"
      }
    },
    "version" : {
      "localizations" : {
        "en" : "Version",
        "zh-CN" : "版本"
      }
    }
  },
  "version" : "1.0"
}
```

保存为 `MewNotch/Resources/Localizable.xcstrings`。

---

### Task 2: 创建 LanguageDefaults 和 LanguageManager

**Files:**
- Create: `MewNotch/DB/UserDefaults/App/LanguageDefaults.swift`
- Create: `MewNotch/ViewModel/LanguageManager.swift`

- [ ] **Step 1: 创建 LanguageDefaults.swift**

```swift
//
//  LanguageDefaults.swift
//  MewNotch
//
//  Created by Claude on 07/05/26.
//

import Foundation

class LanguageDefaults: ObservableObject {

    private static var PREFIX: String = "Language_"

    static let shared = LanguageDefaults()

    private init() {}

    @PrimitiveUserDefault(
        PREFIX + "LanguageCode",
        defaultValue: "en"
    )
    var languageCode: String {
        didSet {
            self.objectWillChange.send()
        }
    }

    var currentLocale: Locale {
        Locale(identifier: languageCode)
    }
}
```

- [ ] **Step 2: 创建 LanguageManager.swift**

```swift
//
//  LanguageManager.swift
//  MewNotch
//
//  Created by Claude on 07/05/26.
//

import SwiftUI

class LanguageManager: ObservableObject {

    static let shared = LanguageManager()

    @Published var currentLocale: Locale

    private var languageDefaults = LanguageDefaults.shared

    private init() {
        currentLocale = languageDefaults.currentLocale
    }

    func updateLocale(languageCode: String) {
        languageDefaults.languageCode = languageCode
        currentLocale = Locale(identifier: languageCode)
    }
}
```

---

### Task 3: 修改 MewNotchApp.swift 应用 locale environment

**Files:**
- Modify: `MewNotch/MewNotchApp.swift`

- [ ] **Step 1: 添加 LanguageManager StateObject**

在 `MewNotchApp.swift` 的属性声明部分添加：

```swift
@StateObject private var languageManager = LanguageManager.shared
```

插入位置：第 20 行之后（updaterViewModel 定义之后）

- [ ] **Step 2: 应用 locale environment**

修改 Settings Scene，添加 locale environment：

```swift
Settings {
    MewSettingsView()
        .modelContainer(sharedModelContainer)
        .environment(\.locale, languageManager.currentLocale)
}
.windowResizability(.contentSize)
```

完整修改后的 `MewNotchApp.swift`：

```swift
//
//  MewNotchApp.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI
import SwiftData
import Sparkle

@main
struct MewNotchApp: App {

    @NSApplicationDelegateAdaptor(MewAppDelegate.self) var mewAppDelegate

    @Environment(\.openWindow) private var openWindow
    @Environment(\.openSettings) private var openSettings

    @StateObject private var updaterViewModel: UpdaterViewModel = .shared
    @StateObject private var languageManager = LanguageManager.shared

    @ObservedObject private var appDefaults = AppDefaults.shared

    @State private var isMenuShown: Bool = true

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError(
                "Could not create ModelContainer: \(error)"
            )
        }
    }()

    init() {
        self._isMenuShown = .init(
            initialValue: self.appDefaults.showMenuIcon
        )
    }

    var body: some Scene {
        MenuBarExtra(
            isInserted: $isMenuShown,
            content: {
                Text("MewNotch")

                NotchOptionsView()
            }
        ) {
            MewNotch.Assets.iconMenuBar
                .renderingMode(.template)
        }
        .onChange(
            of: appDefaults.showMenuIcon
        ) { oldVal, newVal in
            if oldVal != newVal {
                isMenuShown = newVal
            }
        }

        Settings {
            MewSettingsView()
                .modelContainer(sharedModelContainer)
                .environment(\.locale, languageManager.currentLocale)
        }
        .windowResizability(.contentSize)
    }
}
```

---

### Task 4: 添加语言图标和颜色资源

**Files:**
- Modify: `MewNotch/Resources/MewNotch.swift`

- [ ] **Step 1: 在 Assets 类添加语言图标**

在 `MewNotch.swift` 的 `Assets` 类中添加（第 90 行之后）：

```swift
static let icLanguage = Image(systemName: "globe")
```

- [ ] **Step 2: 在 Colors 类添加语言颜色**

在 `Colors` 类中添加（第 127 行之后）：

```swift
static let language = IconColor.cyan
```

---

### Task 5: 修改 GeneraSettingsView 添加语言切换

**Files:**
- Modify: `MewNotch/View/Settings/Pages/GeneraSettingsView.swift`

- [ ] **Step 1: 添加 LanguageDefaults StateObject**

在属性声明部分添加：

```swift
@StateObject var languageDefaults = LanguageDefaults.shared
@StateObject var languageManager = LanguageManager.shared
```

插入位置：第 14 行之后。

- [ ] **Step 2: 在 App Section 添加语言切换设置项**

在 "App" Section 的最后一个 SettingsRow（Status Icon）之后添加：

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
    .labelsHidden()
    .onChange(of: languageDefaults.languageCode) { _, newValue in
        languageManager.updateLocale(languageCode: newValue)
    }
}
```

- [ ] **Step 3: 替换 Section header 文本**

将 Section header 的硬编码文本替换为 LocalizedStringResource：

```swift
} header: {
    Text(LocalizedStringResource("app"))
}
```

以及 System Section header：

```swift
} header: {
    Text(LocalizedStringResource("system"))
}
```

完整修改后的 `GeneraSettingsView.swift`：

```swift
//
//  GeneraSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI
import LaunchAtLogin

struct GeneraSettingsView: View {

    @StateObject var appDefaults = AppDefaults.shared
    @StateObject var notchDefaults = NotchDefaults.shared
    @StateObject var languageDefaults = LanguageDefaults.shared
    @StateObject var languageManager = LanguageManager.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "Launch at Login",
                    subtitle: "Automatically start MewNotch when you log in",
                    icon: MewNotch.Assets.icLaunchAtLogin,
                    color: MewNotch.Colors.style
                ) {
                    LaunchAtLogin.Toggle {
                        Text("")
                    }
                    .labelsHidden()
                }

                SettingsRow(
                    title: "Status Icon",
                    subtitle: "Show icon in menu bar for easy access",
                    icon: MewNotch.Assets.icStatusIcon,
                    color: MewNotch.Colors.general
                ) {
                    Toggle("", isOn: $appDefaults.showMenuIcon)
                }

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
                    .labelsHidden()
                    .onChange(of: languageDefaults.languageCode) { _, newValue in
                        languageManager.updateLocale(languageCode: newValue)
                    }
                }
            } header: {
                Text(LocalizedStringResource("app"))
            }

            Section {
                SettingsRow(
                    title: "Disable System HUD",
                    subtitle: "Hide system volume and brightness overlays",
                    icon: MewNotch.Assets.icDisableSystemHud,
                    color: MewNotch.Colors.systemHud
                ) {
                    Toggle("", isOn: $appDefaults.disableSystemHUD)
                        .onChange(of: appDefaults.disableSystemHUD) { _, newValue in
                            if newValue {
                                if !AXIsProcessTrusted() {
                                    let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
                                    AXIsProcessTrustedWithOptions(options as CFDictionary)
                                }
                                MediaKeyManager.shared.start()
                            } else {
                                MediaKeyManager.shared.stop()
                            }
                        }
                }

                if appDefaults.disableSystemHUD && !AXIsProcessTrusted() {
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            Text("Accessibility permissions are required.")
                        } icon: {
                            MewNotch.Assets.icWarning
                        }
                            .font(.caption)
                            .foregroundStyle(.red)

                        Button("Open System Settings") {
                            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
                            AXIsProcessTrustedWithOptions(options as CFDictionary)
                        }
                        .font(.caption)
                    }
                    .padding(.leading, 44)
                }
            } header: {
                Text(LocalizedStringResource("system"))
            }
        }
        .formStyle(.grouped)
        .navigationTitle("General")
    }
}

#Preview {
    GeneraSettingsView()
}
```

---

### Task 6: 修改 MewSettingsView 替换侧边栏文本

**Files:**
- Modify: `MewNotch/View/Settings/MewSettingsView.swift`

- [ ] **Step 1: 替换侧边栏 NavigationLink 文本**

将所有硬编码的侧边栏标题文本替换为 LocalizedStringResource。

修改第 40 行：

```swift
SettingsSidebarRow(title: "General", icon: MewNotch.Assets.icGeneral, color: MewNotch.Colors.general)
```

替换为：

```swift
SettingsSidebarRow(title: String(localized: "general"), icon: MewNotch.Assets.icGeneral, color: MewNotch.Colors.general)
```

修改第 44 行：

```swift
SettingsSidebarRow(title: "Notch", icon: MewNotch.Assets.icNotch, color: MewNotch.Colors.notch)
```

替换为：

```swift
SettingsSidebarRow(title: String(localized: "notch"), icon: MewNotch.Assets.icNotch, color: MewNotch.Colors.notch)
```

修改第 56 行：

```swift
SettingsSidebarRow(title: "Collapsed", icon: MewNotch.Assets.icHud, color: MewNotch.Colors.hud)
```

替换为：

```swift
SettingsSidebarRow(title: String(localized: "collapsed"), icon: MewNotch.Assets.icHud, color: MewNotch.Colors.hud)
```

修改第 60 行：

```swift
SettingsSidebarRow(title: "Expanded", icon: MewNotch.Assets.icMedia, color: MewNotch.Colors.nowPlaying)
```

替换为：

```swift
SettingsSidebarRow(title: String(localized: "expanded"), icon: MewNotch.Assets.icMedia, color: MewNotch.Colors.nowPlaying)
```

修改第 66 行 Section header：

```swift
Text("Notch Items")
```

替换为：

```swift
Text(LocalizedStringResource("notch_items"))
```

修改第 72 行：

```swift
SettingsSidebarRow(title: "About", icon: MewNotch.Assets.icAbout, color: MewNotch.Colors.about)
```

替换为：

```swift
SettingsSidebarRow(title: String(localized: "about"), icon: MewNotch.Assets.icAbout, color: MewNotch.Colors.about)
```

---

### Task 7: 修改 NotchSettingsView 替换设置文本

**Files:**
- Modify: `MewNotch/View/Settings/Pages/NotchSettingsView.swift`

- [ ] **Step 1: 替换所有 SettingsRow title/subtitle**

需要逐个替换以下文本：

第 24 行 title: `"Show Notch On"` → `String(localized: "show_notch_on")`
第 38 行 subtitle: `"Choose Displays to show notch on"` → `String(localized: "choose_display")`
第 76 行 title: `"Show on Lock Screen"` → `String(localized: "show_on_lock_screen")`
第 77 行 subtitle: `"Incompatible with File Shelf feature"` → `String(localized: "show_on_lock_screen_subtitle")`
第 88 行 title: `"Hide on Full Screen"` → `String(localized: "hide_on_full_screen")`
第 89 行 subtitle: `"Hides the notch when a full screen app is detected"` → `String(localized: "hide_on_full_screen_subtitle")`
第 99 行 title: `"Reset View on Collapse"` → `String(localized: "reset_view_on_collapse")`
第 100 行 subtitle: 动态文本，需要根据 notchDefaults.resetViewInCollapse 状态显示不同翻译
第 114 行 title: `"Height"` → `String(localized: "height")`
第 128 行 title: `"Apply Glass Effect"` → `String(localized: "apply_glass_effect")`
第 129 行 subtitle: `"Forces 'Expand on Hover' to be enabled"` → `String(localized: "apply_glass_effect_subtitle")`
第 143 行 title: `"Expand on Hover"` → `String(localized: "expand_on_hover")`
第 144 行 subtitle: `"Expand notch when hovered.\nDisables click interactions in all HUDs."` → `String(localized: "expand_on_hover_subtitle")`
第 159 行 title: `"Hover Delay"` → `String(localized: "hover_delay")`
第 160 行 subtitle: 动态拼接
第 173 行 title: `"Haptic Feedback"` → `String(localized: "haptic_feedback")`
第 174 行 subtitle: `"Play haptic feedback when hovering over the notch"` → `String(localized: "haptic_feedback_subtitle")`

- [ ] **Step 2: 替换 Section headers**

第 108 行: `"Displays"` → `String(localized: "displays")`
第 136 行: `"Interface"` → `String(localized: "interface")`
第 180 行: `"Interaction"` → `String(localized: "interaction")`

- [ ] **Step 3: 处理动态 subtitle**

对于第 100 行的动态 subtitle，需要使用条件判断：

```swift
subtitle: notchDefaults.resetViewInCollapse ? String(localized: "reset_view_on_collapse_subtitle_true") : String(localized: "reset_view_on_collapse_subtitle_false")
```

对于第 160 行的 Hover Delay subtitle，需要动态拼接：

```swift
subtitle: "\(notchDefaults.expandOnHoverDelay.formatted())" + String(localized: "hover_delay_subtitle")
```

---

### Task 8: 修改 AboutAppView 替换关于页面文本

**Files:**
- Modify: `MewNotch/View/Settings/Pages/AboutAppView.swift`

- [ ] **Step 1: 替换按钮文本**

第 47 行: `"Check for Updates"` → `String(localized: "check_for_updates")`
第 59 行: `"View on GitHub"` → `String(localized: "view_on_github")`

修改后：

```swift
Button(action: {
    updaterViewModel.checkForUpdates()
}) {
    Text(String(localized: "check_for_updates"))
        .font(.system(size: 13, weight: .medium))
        .frame(maxWidth: 160)
}
.controlSize(.large)
.disabled(!updaterViewModel.canCheckForUpdates)

Button(action: {
    if let url = URL(string: "https://github.com/monuk7735/mew-notch") {
        NSWorkspace.shared.open(url)
    }
}) {
    Text(String(localized: "view_on_github"))
        .font(.system(size: 13, weight: .medium))
        .frame(maxWidth: 160)
}
.controlSize(.large)
```

---

### Task 9: 修改 FileShelfView 替换文件架文本

**Files:**
- Modify: `MewNotch/View/Notch/Expanded/ParentViews/FileShelfView.swift`

- [ ] **Step 1: 替换 Drop Files Here 文本**

找到 `Text("Drop Files Here")` 替换为：

```swift
Text(LocalizedStringResource("drop_files_here"))
```

- [ ] **Step 2: 替换 AirDrop 文本**

找到 `Text("AirDrop")` 替换为：

```swift
Text(LocalizedStringResource("airdrop"))
```

---

### Task 10: 修改 MirrorView 替换镜像视图文本

**Files:**
- Modify: `MewNotch/View/Notch/Expanded/ItemViews/MirrorView.swift`

- [ ] **Step 1: 替换 Mirror 文本**

找到所有 `Text("Mirror")` 替换为：

```swift
Text(LocalizedStringResource("mirror"))
```

- [ ] **Step 2: 替换摄像头权限文本**

找到条件文本：

```swift
Text(cameraAuthStatus == .notDetermined ? "Tap to Allow Camera" : "Camera Access Required")
```

替换为：

```swift
Text(cameraAuthStatus == .notDetermined ? String(localized: "tap_to_allow_camera") : String(localized: "camera_access_required"))
```

---

### Task 11: 修改 NowPlayingTextHUDView 替换正在播放文本

**Files:**
- Modify: `MewNotch/View/Notch/Collapsed/HUDView/NowPlayingTextHUDView.swift`

- [ ] **Step 1: 替换 Now Playing 文本**

找到 `Text("Now Playing")` 替换为：

```swift
Text(LocalizedStringResource("now_playing"))
```

---

### Task 12: 修改 PowerHUDView 替换电源 HUD 文本

**Files:**
- Modify: `MewNotch/View/Notch/Collapsed/HUDView/PowerHUDView.swift`

- [ ] **Step 1: 替换 Left 文本**

找到 `Text("Left")` 替换为：

```swift
Text(LocalizedStringResource("left"))
```

---

### Task 13: 测试语言切换功能

**Files:**
- Test: 运行应用并验证语言切换

- [ ] **Step 1: 构建项目**

```bash
xcodebuild -project MewNotch.xcodeproj -scheme MewNotch -destination "platform=macOS" build
```

Expected: 构建成功无错误

- [ ] **Step 2: 运行应用**

打开应用，进入 Settings → General 页面

- [ ] **Step 3: 测试英文显示**

确认默认语言为英文，检查所有 UI 文本显示英文

- [ ] **Step 4: 切换到中文**

点击 Language Picker，选择 "中文"

Expected: 所有 UI 文本立即切换为中文（包括侧边栏、设置项、按钮等）

- [ ] **Step 5: 切换回英文**

点击 Language Picker，选择 "English"

Expected: 所有 UI 文本立即切换回英文

- [ ] **Step 6: 验证持久化**

关闭应用，重新打开

Expected: 语言设置保持上次选择的语言

---

### Task 14: 提交更改

**Files:**
- Git commit

- [ ] **Step 1: 查看修改状态**

```bash
git status
```

- [ ] **Step 2: 添加所有修改文件**

```bash
git add MewNotch/Resources/Localizable.xcstrings \
        MewNotch/DB/UserDefaults/App/LanguageDefaults.swift \
        MewNotch/ViewModel/LanguageManager.swift \
        MewNotch/MewNotchApp.swift \
        MewNotch/Resources/MewNotch.swift \
        MewNotch/View/Settings/Pages/GeneraSettingsView.swift \
        MewNotch/View/Settings/MewSettingsView.swift \
        MewNotch/View/Settings/Pages/NotchSettingsView.swift \
        MewNotch/View/Settings/Pages/AboutAppView.swift \
        MewNotch/View/Notch/Expanded/ParentViews/FileShelfView.swift \
        MewNotch/View/Notch/Expanded/ItemViews/MirrorView.swift \
        MewNotch/View/Notch/Collapsed/HUDView/NowPlayingTextHUDView.swift \
        MewNotch/View/Notch/Collapsed/HUDView/PowerHUDView.swift \
        docs/superpowers/specs/2026-05-07-multilingual-design.md \
        docs/superpowers/plans/2026-05-07-multilingual-support.md
```

- [ ] **Step 3: 创建提交**

```bash
git commit -m "$(cat <<'EOF'
feat: add multilingual support (English/Chinese)

Add i18n support using SwiftUI String Catalog:
- Create Localizable.xcstrings with English and Chinese translations
- Add LanguageDefaults for storing user language preference
- Add LanguageManager for dynamic language switching
- Add language picker in General settings page
- Replace hardcoded text in settings and HUD views
- Apply locale environment to refresh all views on language change

User can switch language in Settings -> General -> Language.
Default language is English. Preference persists across sessions.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
EOF
)"
```

---

## 自检清单

**1. Spec coverage:**
- ✓ 语言切换方式：设置页面手动切换（Task 5）
- ✓ 翻译范围：全部 UI 文本（Tasks 6-12）
- ✓ 文件格式：String Catalog .xcstrings（Task 1）
- ✓ 默认语言：英文（LanguageDefaults defaultValue: "en"）

**2. Placeholder scan:**
- ✓ 无 TBD/TODO
- ✓ 所有代码步骤包含完整代码
- ✓ 无 "implement later" 等占位符
- ✓ 所有文件路径精确

**3. Type consistency:**
- ✓ LanguageDefaults.languageCode 类型为 String，与 Picker tag 一致
- ✓ LanguageManager.currentLocale 类型为 Locale，与 environment(\.locale) 一致
- ✓ LocalizedStringResource key 名称与 String Catalog 定义一致

---

计划已完成。保存到 `docs/superpowers/plans/2026-05-07-multilingual-support.md`。