# XWorkout 🏋️

<div align="center">

<img src="assets/icon.png" alt="XWorkout Logo" width="128" height="128"/>

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green)
![Version](https://img.shields.io/badge/version-4.9.4-brightgreen)

</div>

轻量级健身记录软件 - 简洁、离线、跨平台

## 📱 关于 XWorkout

XWorkout 是一款专为健身爱好者设计的轻量级训练记录应用，采用 Apple 风格的 Cupertino 设计语言，界面简洁美观。支持完全离线使用，你的训练数据完全存储在本地设备中，确保隐私安全。

## ✨ 核心特性

| 特性 | 说明 |
|------|------|
| 🏋️ **训练计划管理** | 创建个性化训练计划，灵活配置训练日与休息日 |
| 📝 **详细训练记录** | 记录每组次数、重量，追踪训练进度 |
| ⏰ **智能休息计时器** | 自动计时，音震提醒，助你科学训练 |
| 📅 **日历视图** | 直观的日历展示，一目了然查看训练历史 |
| 📊 **训练统计** | 查看训练频率、动作统计，了解训练趋势 |
| 🔒 **完全离线** | 本地 SQLite 数据库存储，无需网络 |
| 🎨 **Apple 风格** | Cupertino 设计语言，简洁现代的界面 |
| ⚙️ **高度可定制** | 重量单位、日期格式、训练类型均可自定义 |

## 🖥️ 功能详情

### 🏠 今日训练
- 查看当日训练计划
- 一键开始训练
- 显示上次训练记录参考
- 快速查看训练进度

### 💪 训练计划
- 创建多个训练计划
- 自定义训练周期（每周/每月）
- 灵活配置训练日与休息日
- 每日训练项目安排
- 支持计划激活/停用

### 📋 动作管理
- **预设动作库**：内置 30+ 常用训练动作
  - 通用：负重蜷曲
  - 胸肌与三头：杠铃卧推、平板哑铃卧推、上斜哑铃卧推、蝴蝶机夹胸、器械推胸、碎颅式、绳索过头臂屈伸、绳索下拉直杆
  - 背部与二头：引体向上、高位下拉器械、高位下拉、坐姿划船、t杠划船、器械划船、牧师凳弯举、龙门架弯举、锤式弯举、反向杠铃弯举
  - 肩部与臀腿：坐姿推肩、器械推肩、绳索侧平举、后束器械、绳索面拉、手腕正手弯举、手腕反手弯举、靠背深蹲机、正蹲机、高脚杯深蹲
- 自定义训练动作
- 动作与训练类型联动
- 支持增删改查

### 🏋️ 训练类型
- **通用** - 可添加到任意训练计划
- **胸肌与三头** - 胸部与三头肌训练
- **背部与二头** - 背部与二头肌训练
- **肩部与臀腿** - 肩部与臀腿训练
- 自定义训练类型

### 📅 历史记录
- 查看完整训练历史
- 日历视图直观展示
- 训练详情回顾
- 数据趋势分析

### 📊 训练统计
- 训练频率统计
- 动作使用统计
- 训练趋势分析

### ⏰ 休息计时器
- 自定义休息时长（60/90/120/180秒）
- 自动开始计时
- 声音提醒
- 震动反馈

### ⚙️ 设置
- 重量单位切换（kg/lbs）
- 日期格式选择
- 每周首日设置
- 休息计时器偏好设置

### 📦 数据管理
- 数据导出备份
- 数据恢复

## 🛠️ 技术栈

| 技术 | 说明 |
|------|------|
| Flutter | 跨平台 UI 框架 |
| Riverpod | 状态管理 |
| Drift | SQLite ORM 数据库 |
| go_router | 声明式路由 |
| Cupertino | Apple 风格组件 |

## 🚀 快速开始

### 环境要求

- Flutter 3.x+
- Dart 3.x+
- Android SDK (开发 Android)
- Xcode (开发 iOS macOS)

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

### 构建 APK

```bash
# Debug 构建
flutter build apk --debug

# Release 构建 (单 APK)
flutter build apk --release

# Release 构建 (按架构分离)
flutter build apk --release --split-per-abi
```

分离构建的 APK 文件：
- `xworkout-{version}-arm64-v8a.apk` - 64位 ARM
- `xworkout-{version}-armeabi-v7a.apk` - 32位 ARM
- `xworkout-{version}-x86_64.apk` - x86_64 模拟器

## 📁 项目结构

```
lib/
├── core/                    # 核心功能
│   ├── database/           # 数据库层 (Drift)
│   │   ├── database.dart # 数据库定义
│   │   ├── tables.dart   # 数据表定义
│   │   └── ...
│   ├── router/            # 路由配置 (go_router)
│   └── theme/             # 主题系统
├── features/               # 功能模块
│   ├── today/            # 今日训练
│   │   ├── data/         # 数据层
│   │   ├── domain/       # 领域层
│   │   └── presentation/ # 展示层
│   ├── training/         # 训练计划管理
│   ├── workout/          # 训练执行
│   ├── history/          # 历史记录
│   ├── statistics/       # 训练统计
│   ├── settings/         # 应用设置
│   └── more/            # 更多设置
├── shared/                # 共享组件
│   └── widgets/          # 通用组件
└── main.dart             # 应用入口
```

## 📋 数据模型

| 表名 | 说明 |
|------|------|
| WorkoutTypes | 训练类型 |
| Exercises | 训练动作 |
| WorkoutSessions | 训练记录 |
| WorkoutSets | 训练组数 |
| WorkoutPlans | 训练计划 |
| PlanDays | 计划中的天数 |
| DayExercises | 每日训练动作 |
| DailyRecords | 每日记录 |
| ExerciseRecords | 动作记录 |
| AppSettings | 应用设置 |

## 📝 更新日志

### v4.9.4 (2026-02-23)
- 修复：允许「通用」类别动作添加到其他类别训练中

### v4.9.3 (2026-02-23)
- 更新训练类别名称
  - 胸部 → 胸肌与三头
  - 背部 → 背部与二头
  - 腿部 → 肩部与臀腿
- 新增 30 个预设训练动作
- 更新应用图标

### v4.9.0 - v4.9.2
- 优化界面显示
- 修复已知问题

详见 [更新日志](docs/update-logs/)

## 👤 作者

**Aixkevin**
- GitHub: [https://github.com/AixKevin](https://github.com/AixKevin)
- 项目地址: [https://github.com/AixKevin/XWorkout](https://github.com/AixKevin/XWorkout)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License - 查看 [LICENSE](LICENSE) 了解更多
