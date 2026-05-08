# Changelog

All notable changes to MewNotch will be documented in this file.

## [2.3.1] - 2026-05-08

### Bug 修复
- **日历权限问题**：添加 entitlements 权限声明，修复授权按钮无响应问题
  - 添加 `com.apple.security.personal-information.calendars` entitlement
  - 添加 `com.apple.security.personal-information.reminders` entitlement
  - 改进权限请求逻辑，支持 macOS 14+ 和旧版本
  - 权限被拒绝时自动打开系统设置隐私页面
- **多屏幕歌曲切换**：修复副屏幕显示方块问题
  - NowPlayingTextHUDView 根据屏幕类型选择不同形状
  - 刘海屏使用 NotchShape，普通屏幕使用 RoundedRectangle
  - 添加背景和材质效果
- **番茄钟展开状态**：展开时隐藏刘海左右 HUD 显示
  - 避免折叠和展开状态重复显示

### 改进
- 添加调试日志帮助追踪日历权限状态
- 添加授权按钮悬停提示

## [2.3.0] - 2026-05-08

### 新增功能
- **多语言支持**：完整的中英文界面切换，130+ 项翻译
- **番茄钟实时显示**：
  - 折叠状态：刘海左侧显示状态图标，右侧显示倒计时时间
  - 展开状态：完整的番茄钟控制界面
  - 实时倒计时刷新，支持工作/短休息/长休息三种模式
- **日历集成**：显示今日日程、进行中的事件、即将到来的事件
- **提词器功能**：导入脚本文件，支持滚动播放
- **待办事项提醒**：显示待办列表，过期提醒，与系统提醒事项集成
- **计时器功能**：自定义倒计时，支持多个计时器
- **发布系统**：Sparkle 自动更新，GitHub Actions 自动发布

### 改进
- 优化折叠状态 HUD 显示布局，使用 MinimalHUDView 模式
- 展开视图宽度自适应：
  - 主页：保持刘海下方原样扩展
  - 其他视图：限制最大宽度防止超出屏幕
- 完善设置页面中文翻译
- PomodoroMiniView 改为垂直布局，与其他 MiniView 保持一致

### 技术改进
- 使用 LocalizedStringKey 实现多语言切换
- 添加 PomodoroManager 单例管理番茄钟状态
- Timer.scheduledTimer 确保倒计时实时刷新
- 添加 .fixedSize() 防止视图压缩
- 创建发布脚本和 appcast 更新工具

## [2.2.1] - 2026-05-07

### 新增功能
- 生产力工具套件初始版本
- 基础番茄钟功能
- 基础日历显示
- 基础提词器
- 基础待办事项
- 基础计时器

## [2.2.0] - 2026-04-XX

### 新增功能
- NowPlaying 音乐播放器集成
- Bash 命令输出显示
- Mirror 镜像摄像头功能
- Shelf 文件收纳功能

## [2.0.0] - 2026-02-XX

### 新增功能
- 凹口 HUD 基础功能
- 亮度、音量、电源状态显示
- 媒体键监听
- 多屏幕支持
- Glass 效果