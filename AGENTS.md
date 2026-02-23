# AGENTS.md - XWorkout 开发指南

本文档为在此代码库中工作的 AI 代理提供开发规范和指南。

---

## 📋 目录

1. [项目概述](#项目概述)
2. [常用命令](#常用命令)
3. [版本管理与发布流程](#版本管理与发布流程) ⭐重要
4. [代码风格规范](#代码风格规范)
5. [项目结构](#项目结构)
6. [状态管理 Riverpod](#状态管理-riverpod)
7. [数据库 Drift](#数据库-drift)
8. [UI 开发 Cupertino](#ui开发-cupertino)
9. [错误处理](#错误处理)
10. [本地化](#本地化)
11. [依赖管理](#依赖管理)
12. [数据模型](#数据模型)
13. [常见问题](#常见问题)

---

## 项目概述

- **项目名称**: XWorkout
- **类型**: Flutter 健身记录应用
- **技术栈**: Flutter 3.x, Riverpod, Drift, go_router, Cupertino UI

---

## 常用命令

### Flutter 开发
```bash
# 安装依赖
flutter pub get

# 代码生成 (重要！修改数据库后必须运行)
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch

# 运行应用
flutter run

# 构建 APK
flutter build apk --debug              # Debug 构建
flutter build apk --release           # Release 构建 (单 APK)
flutter build apk --release --split-per-abi  # Release 构建 (按架构分离)

# 代码质量
flutter analyze
flutter analyze --no-fatal-infos --no-fatal-warnings
dart format .

# 测试
flutter test
flutter test test/path/to/file_test.dart
flutter test --name "test_name_pattern"
```

### Android 相关
```bash
# 查看已连接的 ADB 设备
adb devices

# 安装 APK 到设备 (-r 表示覆盖安装)
adb install -r build/app/outputs/flutter-apk/xworkout-4.9.x-arm64-v8a.apk

# 卸载 APK
adb uninstall com.example.xworkout

# 查看设备日志
adb logcat
```

### Git 与 GitHub
```bash
# 提交所有更改
git add -A && git commit -m "message"

# 推送到远程
git push origin master

# 创建 GitHub Release (需要先安装 gh CLI)
gh release create v4.9.5 --title "v4.9.5 Release" --notes "更新内容" apks...
```

---

## 版本管理与发布流程 ⭐

本项目使用 **pubspec.yaml** 作为版本号的单一可信来源。

### 完整发布流程

```bash
# 1. 修改版本号 (只需修改这一处)
#    编辑 pubspec.yaml，将 version: x.y.z 改为新版本号

# 2. 运行版本同步脚本 (自动更新其他文件)
dart run scripts/sync_version.dart

# 3. 手动补充 README.md 中的更新日志内容

# 4. 构建 APK (按架构分离)
flutter build apk --release --split-per-abi

# 5. 重命名 APK 文件
cd build/app/outputs/flutter-apk
mv app-arm64-v8a-release.apk xworkout-{version}-arm64-v8a.apk
mv app-armeabi-v7a-release.apk xworkout-{version}-armeabi-v7a.apk
mv app-x86_64-release.apk xworkout-{version}-x86_64.apk

# 6. 安装 arm64 版本到设备
adb install -r xworkout-{version}-arm64-v8a.apk

# 7. 提交到 Git
git add -A && git commit -m "release: v{x.y.z}"

# 8. 推送到 GitHub
git push origin master

# 9. 创建 GitHub Release
gh release create v{x.y.z} --title "v{x.y.z} Release" --notes "更新内容" \
  xworkout-{version}-arm64-v8a.apk \
  xworkout-{version}-armeabi-v7a.apk \
  xworkout-{version}-x86_64.apk
```

### 版本号规则

| 格式 | 示例 | 说明 |
|------|------|------|
| `主版本.次版本.修订号` | `4.9.5` | pubspec.yaml 中的版本格式 |
| Build 号 | `5` | 自动从修订号提取 (`4.9.5` → Build `5`) |

### 同步脚本

- **脚本位置**: `scripts/sync_version.dart`
- **Windows 脚本**: `scripts/sync_version.bat`
- **自动更新内容**:
  - `lib/features/more/presentation/more_screen.dart` - 应用内版本显示
  - `README.md` - 版本徽章 + 自动添加更新日志条目

### 一键发布脚本 (可选)

可以创建 `release.sh` 实现自动化:

```bash
#!/bin/bash
VERSION=$1

# 修改版本号
sed -i "s/version: .*/version: $VERSION/" pubspec.yaml

# 同步版本
dart run scripts/sync_version.dart

# 构建
flutter build apk --release --split-per-abi

# 重命名
cd build/app/outputs/flutter-apk
mv app-arm64-v8a-release.apk xworkout-$VERSION-arm64-v8a.apk
mv app-armeabi-v7a-release.apk xworkout-$VERSION-armeabi-v7a.apk
mv app-x86_64-release.apk xworkout-$VERSION-x86_64.apk

# 安装
adb install -r xworkout-$VERSION-arm64-v8a.apk

# Git
cd ../..
git add -A && git commit -m "release: v$VERSION" && git push

# GitHub Release
gh release create v$VERSION --title "v$VERSION Release" \
  build/app/outputs/flutter-apk/xworkout-$VERSION-arm64-v8a.apk \
  build/app/outputs/flutter-apk/xworkout-$VERSION-armeabi-v7a.apk \
  build/app/outputs/flutter-apk/xworkout-$VERSION-x86_64.apk
```

---

## 代码风格规范

### 格式化
- **缩进**: 2 空格
- **行长度**: 无硬性限制
- **语句结尾**: 不需要分号

### 导入顺序
1. Dart SDK (`dart:xxx`)
2. Flutter (`package:flutter/xxx`)
3. 第三方包
4. 项目内部 (`package:xworkout/xxx`)

### 命名规范

| 类型 | 规则 | 示例 |
|------|------|------|
| 文件名 | snake_case | `app_router.dart` |
| 类名 | PascalCase | `class Exercise` |
| 方法/变量 | camelCase | `final exerciseName` |
| 私有成员 | 下划线前缀 | `final _database` |

### 类型声明
- **必须声明返回类型**: `always_declare_return_types: true`
- **优先 const**: `prefer_const_constructors: true`
- **优先 final**: `prefer_final_locals: true`

---

## 项目结构

```
lib/
├── core/                    # 核心功能
│   ├── database/          # 数据库层 (Drift)
│   │   ├── database.dart  # 数据库定义
│   │   ├── tables.dart   # 数据表定义
│   │   └── ...
│   ├── router/            # 路由配置 (go_router)
│   └── theme/             # 主题系统
├── features/               # 功能模块
│   ├── today/           # 今日训练
│   │   ├── data/        # 数据层
│   │   ├── domain/      # 领域层
│   │   └── presentation/ # 展示层
│   ├── training/        # 训练计划管理
│   ├── workout/         # 训练执行
│   ├── history/         # 历史记录
│   ├── statistics/     # 训练统计
│   ├── settings/        # 应用设置
│   └── more/          # 更多设置
├── shared/               # 共享组件
│   └── widgets/        # 通用组件
└── main.dart           # 应用入口
```

---

## 状态管理 (Riverpod)

```dart
final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return ExerciseRepository(ref.watch(databaseProvider));
});

class ExerciseNotifier extends StateNotifier<AsyncValue<List<Exercise>>> {
  ExerciseNotifier(this._repository) : super(const AsyncValue.loading());
  final ExerciseRepository _repository;
  Future<void> loadExercises() async { ... }
}

final exerciseNotifierProvider = StateNotifierProvider<ExerciseNotifier, AsyncValue<List<Exercise>>>((ref) {
  return ExerciseNotifier(ref.watch(exerciseRepositoryProvider));
});
```

---

## 数据库 (Drift)

```dart
class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get defaultSets => integer().withDefault(const Constant(3))();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<AppDatabase> with _$ExerciseDaoMixin {
  Future<List<Exercise>> getAllExercises() => select(exercises).get();
  Stream<List<Exercise>> watchAllExercises() => select(exercises).watch();
}
```

**注意**: 修改表结构后需重新运行 `dart run build_runner build --delete-conflicting-outputs`

---

## UI 开发 (Cupertino)

```dart
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('今日')),
      child: SafeArea(child: /* 内容 */),
    );
  }
}
```

---

## 错误处理
- **避免 print**: 使用 `debugPrint`
- **async/await**: 必须正确处理 Future 错误

```dart
try {
  await repository.saveExercise(exercise);
} catch (e, stack) {
  debugPrint('保存失败: $e');
  rethrow;
}
```

---

## 本地化
- **语言**: 简体中文 (zh-CN)
- **用户可见文本**: 使用中文
- **内部变量/方法**: 使用英文命名

---

## 依赖管理

| 依赖 | 用途 |
|------|------|
| flutter_riverpod | 状态管理 |
| drift | SQLite 数据库 |
| go_router | 路由 |
| phosphor_flutter | 图标 |
| cupertino_icons | Apple 风格图标 |
| intl | 日期处理 |
| fl_chart | 图表 |
| share_plus | 分享功能 |
| permission_handler | 权限管理 |
| flutter_local_notifications | 本地通知 |
| table_calendar | 日历组件 |
| pdf | PDF 生成 |
| file_picker | 文件选择 |

---

## 数据模型

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

---

## 应用图标管理

### 更改应用图标

1. 替换 `assets/icon.png` 为新图标 (建议 1024x1024 PNG)
2. 复制到所有 mipmap 目录:
   ```bash
   cp assets/icon.png android/app/src/main/res/mipmap-mdpi/ic_launcher.png
   cp assets/icon.png android/app/src/main/res/mipmap-hdpi/ic_launcher.png
   cp assets/icon.png android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
   cp assets/icon.png android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
   cp assets/icon.png android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
   ```
3. 重新构建 APK

---

## 常见问题

**Q: 数据库报错 "Missing table"**
A: 运行 `dart run build_runner build --delete-conflicting-outputs`

**Q: APK 找不到或构建失败**
A: 
1. 运行 `flutter clean` 清理
2. 运行 `flutter pub get` 重新获取依赖
3. 确保 Android SDK 配置正确

**Q: ADB 设备未找到**
A:
1. 检查手机是否通过 USB 连接并开启开发者模式
2. 运行 `adb devices` 查看设备列表
3. 如果是无线连接，确保在同一网络下

**Q: GitHub CLI (gh) 未找到**
A: 
- Windows: 安装 GitHub CLI 后使用完整路径 `C:\Program Files\GitHub CLI\gh.exe`
- 或添加到 PATH 环境变量
