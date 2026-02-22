# XWorkout 🏋️

<div align="center">

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green)

</div>

轻量级健身记录软件 - 简洁、离线、跨平台

## 简介

XWorkout 是一款简洁、现代化的健身记录应用，支持离线使用，完全掌控你的训练数据。

## 特性

- 🏋️ **自定义训练项目** - 完全自定义，不局限于预设
- 📅 **灵活计划** - 自定义训练周期，配置训练日/休息日
- 📝 **详细记录** - 记录每组次数、重量
- 😴 **偷懒功能** - 支持请假和撤销
- 📱 **跨平台** - 基于Flutter，支持Android/iOS/Web
- 🎨 **Apple风格** - 简洁现代的界面设计
- 🔒 **离线优先** - 本地存储，无需网络

## 功能详情

### 🏠 今日页面
- 查看当天训练计划
- 一键开始训练
- 偷懒/撤销偷懒功能
- 快速查看上次训练记录

### 💪 训练类型
- 支持胸部、背部、腿部等多种训练类型
- **通用类型**：可添加通用动作到任意训练计划
- 自定义训练类型

### 📋 动作管理
- 完全自定义训练动作
- 动作与类型自动联动
- 支持增删改查

### 📅 训练计划
- 自定义训练周期
- 配置训练日/休息日
- 每日训练项目安排

### 📊 训练记录
- 记录每组次数和重量
- 查看历史训练数据
- 日历视图直观查看训练历史
- 数据导出备份

### ⏰ 休息计时器
- 自定义休息时长
- 自动开始计时
- 声音和震动提醒

### ⚙️ 更多设置
- 重量单位切换 (kg/lbs)
- 日期格式选择
- 每周首日设置

## 技术栈

| 技术 | 说明 |
|------|------|
| Flutter | 跨平台框架 |
| Riverpod | 状态管理 |
| Drift | SQLite数据库 |
| go_router | 路由管理 |
| Cupertino | Apple风格UI |

## 快速开始

### 环境要求

- Flutter 3.x+
- Dart 3.x+
- Android SDK (开发Android)
- Xcode (开发iOS，macOS)

### 安装

```bash
# 克隆项目
git clone https://github.com/AixKevin/XWorkout.git
cd XWorkout

# 安装依赖
flutter pub get

# 生成数据库代码
dart run build_runner build --delete-conflicting-outputs

# 运行应用
flutter run
```

### 构建

```bash
# 构建 Android APK (Debug)
flutter build apk --debug

# 构建 Android APK (Release)
flutter build apk --release

# 构建 iOS
flutter build ios
```

## 项目结构

```
lib/
├── core/                    # 核心功能
│   ├── database/           # 数据库层 (Drift)
│   ├── router/             # 路由配置 (go_router)
│   └── theme/              # 主题系统
├── features/               # 功能模块
│   ├── today/             # 今日页面
│   ├── training/          # 训练管理
│   ├── workout/           # 训练执行
│   ├── history/           # 历史记录
│   ├── settings/          # 应用设置
│   └── more/              # 更多设置
├── shared/                 # 共享组件
└── main.dart              # 应用入口
```

## 更新日志

### v4.9.0 (2024-02-22)
- 修复子界面返回按钮显示问题
- 优化返回按钮为左尖括号图标

### v4.8.0 (2024-02-22)
- 修复训练中界面顶部重复内容问题
- 优化按钮布局和可滑动区域
- 添加通用训练类型
- 动作管理和新建项目页面分类与类型编辑联动

详见 [更新日志](docs/update-logs/)

## 作者

**Aixkevin**
- GitHub: [https://github.com/AixKevin](https://github.com/AixKevin)
- 项目地址: [https://github.com/AixKevin/XWorkout](https://github.com/AixKevin/XWorkout)

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License - 查看 [LICENSE](LICENSE) 了解更多
