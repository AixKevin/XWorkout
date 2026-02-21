# XWorkout

轻量级健身记录软件

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
git clone https://github.com/your-repo/XWorkout.git
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
# 构建 Android APK
flutter build apk --debug

# 构建 Android Release
flutter build apk --release

# 构建 iOS
flutter build ios
```

## 项目结构

```
lib/
├── core/                    # 核心功能
│   ├── database/           # 数据库层
│   ├── router/             # 路由配置
│   └── theme/              # 主题系统
├── features/               # 功能模块
│   ├── today/             # 今日页面
│   ├── training/          # 训练管理
│   └── more/             # 更多设置
├── shared/                 # 共享组件
└── main.dart              # 应用入口
```

## 功能说明

### 今日页面
- 查看当天训练计划
- 开始/记录训练
- 偷懒/撤销偷懒

### 训练页面
- 管理训练项目（增删改查）
- 创建/配置健身计划
- 设置训练周期和每日项目

### 更多
- 历史记录
- 导出数据
- 应用设置
- 关于

## 更新日志

详见 [docs/update-logs/](docs/update-logs/)

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License
