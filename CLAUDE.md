# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MewNotch 是 macOS 凹口 HUD 应用，将 Mac 凹口转换为可自定义的状态显示区。支持亮度、音量、电源状态、媒体播放等功能显示。

## Build Commands

```bash
# 构建项目
xcodebuild -project MewNotch.xcodeproj -scheme MewNotch -destination "platform=macOS"

# 解析 Swift Package 依赖
xcodebuild -resolvePackageDependencies -project MewNotch.xcodeproj

# 清理构建
xcodebuild clean -project MewNotch.xcodeproj -scheme MewNotch
```

## Architecture

### MVVM Pattern

- **View**: `MewNotch/View/` — SwiftUI 视图层
- **ViewModel**: `MewNotch/ViewModel/` — ObservableObject 状态管理
- **Models**: `MewNotch/Models/` — 数据模型和枚举

### Core Components

**NotchManager** (`Utils/NotchManager.swift`)
- 管理凹口窗口在多个屏幕上的创建和刷新
- 监听屏幕变化事件
- 处理全屏状态下的凹口隐藏

**NotchSpaceManager** (`Utils/NotchSpaceManager.swift`)
- 使用 CGSSpace (私有 API) 将窗口放置在最高层级
- 确保凹口始终在最上层显示

**CollapsedNotchViewModel** (`ViewModel/Notch/CollapsedNotchViewModel.swift`)
- 监听系统事件：音量、亮度、电源、媒体播放
- 通过 NotificationCenter 接收 Objective-C 层广播
- 管理 HUD 显示状态和定时器

### System Integration (Objective-C Bridge)

音频和亮度控制使用 Objective-C 实现，通过 bridging header 连接 Swift：

- `Utils/Helpers/AudioControl/AudioInput.m/.h` — 输入音频设备监听
- `Utils/Helpers/AudioControl/AudioOutput.m/.h` — 输出音频设备监听
- `Utils/Helpers/Brightness/Brightness.m/.h` — 显示亮度监听

依赖私有框架：
- `SkyLight.framework` — 窗口层级管理
- `DisplayServices.framework` — 显示服务
- `MediaRemote.framework` — 媒体播放状态

### Settings/UserDefaults Pattern

使用自定义 Property Wrapper：

```swift
@PrimitiveUserDefault("Key_Name", defaultValue: value)
var property: Type

@CodableUserDefault("Key_Name", defaultValue: value)
var property: CodableType
```

Defaults 文件组织在 `MewNotch/DB/UserDefaults/`:
- `App/` — 应用全局设置
- `HUD/` — HUD 相关设置，遵循 `HUDDefaultsProtocol`
- `ExpandedItems/` — 扩展凹口项设置 (Mirror, NowPlaying, Bash, Shelf)

### Expanded Notch Items

`ExpandedNotchItem` 枚举定义可展开项：
- `.Mirror` — 镜像摄像头视图
- `.NowPlaying` — 媒体播放详情
- `.Bash` — Bash 命令输出

添加新扩展项需：
1. 在 `ExpandedNotchItem` 添加新 case
2. 创建对应 View 在 `View/Notch/Expanded/ItemViews/`
3. 创建对应 Defaults 在 `DB/UserDefaults/ExpandedItems/`
4. 更新 `ExpandedNotchView` 的 switch 语句

## Key Files

- `MewNotchApp.swift` — App 入口，MenuBarExtra 和 Settings Scene
- `MewAppDelegate.swift` — AppDelegate，初始化系统监听器
- `NotchView.swift` — 凹口主视图，组合 Collapsed 和 Expanded 视图
- `MewSettingsView.swift` — 设置窗口 NavigationSplitView 结构

## Dependencies

- Lottie (动画)
- LaunchAtLogin-Modern
- SwiftyJSON
- Sparkle (自动更新)
- MacroVisionKit (全屏检测)

## macOS Requirements

- macOS 14.0+
- 需要辅助功能权限用于媒体键监听