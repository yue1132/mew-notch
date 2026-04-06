<img src=".github/res/MewNotch-Logo.png" width="200" alt="App icon" align="left"/>

<div>
<h3 style="font-size: 2.5rem; letter-spacing: 1px;">MewNotch</h3>
<p style="font-size: 1.15rem; font-weight: 500;">
    <strong>让 Mac 刘海真正变得有用！</strong><br>
    MewNotch 是一款免费开源的 macOS 应用，将刘海区域变为可自定义的 HUD，支持亮度、音量、电源状态等多种信息显示。简洁、美观、注重隐私。
  </p>

<br/><br/>

<div align="center">

[![GitHub License](https://img.shields.io/github/license/monuk7735/mew-notch)](LICENSE)
  [![Downloads](https://img.shields.io/github/downloads/monuk7735/mew-notch/total.svg)](https://github.com/monuk7735/mew-notch/releases)
  [![Issues](https://img.shields.io/github/issues/monuk7735/mew-notch.svg)](https://github.com/monuk7735/mew-notch/issues)
  [![Pull Requests](https://img.shields.io/github/issues-pr/monuk7735/mew-notch.svg)](https://github.com/monuk7735/mew-notch/pulls)
  [![macOS Version](https://img.shields.io/badge/macOS-14.0%2B-blue.svg)](https://www.apple.com/macos/)

<br/>

[English](README.md) | 中文

<br/>

<a href="https://github.com/monuk7735/mew-notch/releases"><img src=".github/res/macOS-Download.png" width="160" alt="Download for macOS"/></a>

<br/>

<img src=".github/res/Screenshot.png" width="100%" alt="MewNotch Preview"/><br/>

</div>

<hr>

## 功能特性

- **亮度显示** - 实时显示亮度调节，支持自动亮度变化提示。
- **音量显示** - 在刘海区域直接显示输入/输出音量变化。
- **系统 HUD 替换** - 可选隐藏 macOS 原生 HUD，获得更简洁的体验。
- **文件架** - 将文件拖拽到刘海区域快速访问。**支持持久化存储！** 重启后文件仍然保留。
- **电源状态** - 显示当前电源来源。**新增：** 可切换"剩余时间"显示。
- **锁屏显示** - 即使在 macOS 锁屏界面也能看到刘海 HUD。
- **正在播放** - 在刘海区域直接控制正在播放的媒体。展开刘海可获取更多控制选项。
- **镜子** - 通过展开的刘海视图快速查看摄像头画面，支持自定义圆角。
- **Bash 脚本视图** - 在展开的刘海中运行和显示 Bash 命令。
- **系统监控** - 展开刘海中实时显示 CPU、内存和网络使用情况，悬停可查看 Top 进程。折叠态刘海左右对称展示 CPU（左）和内存（右）百分比。
- **日历与提醒事项** - 在展开刘海中显示今日日历事件和即将到来的提醒事项。折叠态刘海显示下一个事件的倒计时。
- **计时器与番茄钟** - 在折叠态刘海 HUD 中显示倒计时器和番茄钟模式，支持暂停/继续控制。
- **蓝牙** - 在展开刘海中查看已连接的蓝牙设备及电量信息。
- **自定义布局** - 拖拽排序刘海项目，按你的工作流自由排列。
- **自动更新** - 内置更新器（Sparkle），保持应用始终为最新版本。
- **现代设置界面** - 全新设计的设置体验，更易于自定义。
- **全自定义刘海体验** - 选择要在哪些显示器上显示刘海。
- **SwiftUI 驱动的 UI** - 流畅动画与现代 macOS 风格。

## 安装

### Homebrew

```bash
brew install --cask monuk7735/tap/mew-notch --no-quarantine
```

### 手动下载

1. 从 [GitHub Releases](https://github.com/monuk7735/mew-notch/releases) 下载最新版本。
2. 将应用移至"应用程序"文件夹。
3. 运行应用，如提示则授予相关权限。

### ⚠️ 遇到"已损坏"或"未识别开发者"错误？

> 目前尚未拥有 Apple 开发者账号，因此首次启动时可能会弹出提示。

**方法一（推荐）：通过系统设置允许**

1. 打开 **系统设置** → **隐私与安全性**。
2. 向下滚动至 **安全性** 部分。
3. 找到"MewNotch 已被阻止..."提示，点击 **仍要打开**。
4. 在确认弹窗中点击 **打开**。

**方法二（高级）：在终端中运行以下命令**

```bash
xattr -cr /Applications/MewNotch.app
```

此命令会移除 macOS 对网络下载应用添加的"隔离"标记，解决误报问题。

- `xattr`：用于修改文件属性的工具。
- `-c`：清除所有属性（移除"隔离"标记）。
- `-r`：递归处理（应用于应用包内的所有文件）。

## 使用方法

1. 启动 **MewNotch**。
2. 如需打开设置，再次启动应用即可。非刘海屏设备首次启动不会显示刘海。
3. 使用键盘或 Touch Bar 调节音量或亮度。
4. 在设置中自定义要在不同或所有显示器上显示刘海。
5. 享受刘海上的精美视觉反馈！

## 开发路线

- [x] ~~支持不同类型的 HUD UI~~
- [x] ~~允许用户切换每种 HUD 变体的使用~~
- [x] ~~菜单栏图标显示应用运行状态~~
- [x] ~~Touch Bar 支持~~
- [x] ~~正在播放音乐 HUD~~
- [x] ~~正在播放 HUD 操作，悬停查看效果~~
- [x] ~~展开刘海中的正在播放详情~~
- [x] ~~悬停展开刘海~~
- [x] ~~镜子视图~~
- [x] ~~完全控制刘海在哪些显示器上显示~~
- [x] ~~macOS 15.4 及以上版本正在播放媒体支持~~
- [x] ~~展开刘海中的文件架~~
- [x] ~~文件架跨重启持久化~~
- [ ] 让文件架支持 **锁屏显示** 模式（目前因安全性互斥）
- [ ] 键盘背光变化 HUD
- [ ] 探索更多基于刘海的实用功能

## 依赖

- [Lottie](https://github.com/airbnb/lottie-ios)
- [LaunchAtLogin-Modern](https://github.com/sindresorhus/LaunchAtLogin-Modern)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [Sparkle](https://github.com/sparkle-project/Sparkle)
- [MacroVisionKit](https://github.com/TheBoredTeam/MacroVisionKit)

## 参与贡献

欢迎贡献！随时提交 Issue 或 Pull Request。

## 许可证

本项目基于 [GPLv3 许可证](LICENSE) 开源。

## 致谢

- 灵感来源于让 Mac 刘海真正有用的想法！
- 使用 Swift 和 SwiftUI 用 ♥️ 构建。
- 部分系统集成为 😭 使用 Objective-C 构建。
- 特别感谢以下 GitHub 仓库提供的代码和灵感：
  - [mediaremote-adapter](https://github.com/ungive/mediaremote-adapter)
  - [SlimHUD](https://github.com/AlexPerathoner/SlimHUD)
  - [SkyLightWindow](https://github.com/Lakr233/SkyLightWindow)
  - [EnergyBar](https://github.com/billziss-gh/EnergyBar)
  - [boring.notch](https://github.com/TheBoredTeam/boring.notch)
