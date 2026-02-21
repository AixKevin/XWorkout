# AGENTS.md - XWorkout 开发指南

本文档为在此代码库中工作的 AI 代理提供开发规范和指南。

## 项目概述

- **项目名称**: XWorkout
- **类型**: Flutter 健身记录应用
- **目标平台**: Android (优先), iOS/Web (后续)
- **技术栈**: Flutter 3.x, Riverpod, Drift, go_router, Cupertino UI

---

## 常用命令

### 开发环境
```bash
# 获取依赖
flutter pub get

# 运行代码生成 (Drift, Riverpod)
dart run build_runner build --delete-conflicting-outputs

# 监听代码变化自动重新生成
dart run build_runner watch
```

### 构建与运行
```bash
# 调试模式运行
flutter run

# 构建 APK (调试)
flutter build apk --debug

# 构建 APK (发布)
flutter build apk --release

# 构建 Web
flutter build web
```

### 代码质量
```bash
# 分析代码 (检查错误和警告)
flutter analyze

# 仅显示错误
flutter analyze --no-fatal-infos --no-fatal-warnings

# 格式化代码
dart format .

# 运行测试
flutter test

# 运行单个测试文件
flutter test test/path/to/file_test.dart

# 运行单个测试
flutter test --name "test_name_pattern"
```

---

## 代码风格规范

### 格式化

- **缩进**: 2 空格 (非 Tab)
- **行长度**: 无硬性限制 (analysis_options.yaml 设置 `lines_longer_than_80_chars: false`)
- **语句结尾**: 不需要分号 (Dart 风格)
- **空行**: 适度使用空行分隔逻辑块

### 导入规则

**包导入顺序**:
1. Dart SDK 导入 (`dart:xxx`)
2. Flutter 框架导入 (`package:flutter/xxx`)
3. 第三方包导入
4. 项目内部导入 (`package:xworkout/xxx`)

**示例**:
```dart
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/features/today/presentation/today_screen.dart';
```

### 命名规范

| 类型 | 规则 | 示例 |
|------|------|------|
| 文件名 | snake_case | `app_router.dart`, `today_screen.dart` |
| 类名 | PascalCase | `class XWorkoutApp`, `class Exercise` |
| 方法/变量 | camelCase | `void main()`, `final exerciseName` |
| 常量 | camelCase | `const primaryColor`, `final maxSets` |
| 私有成员 | 下划线前缀 | `final _database`, `void _init()` |

### 类型声明

- **必须声明返回类型**: `always_declare_return_types: true`
- **优先使用 const**: 尽可能使用 `const` 构造函数
- **优先使用 final**: 局部变量优先使用 `final`
- **避免 dynamic**: 尽量避免 dynamic 类型

**示例**:
```dart
// Good
void main() { }
int calculateSets(int base) => base * 3;
final List<Exercise> exercises = [];

// Bad
main() { }
var calculateSets = (base) => base * 3;
var exercises = [];
```

### 构造函数

- **优先 const**: 优先使用 const 构造函数
- **子属性排序**: `sort_child_properties_last: true`

```dart
// Good
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    this.onTap,
  });

  final Exercise exercise;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(exercise.name),
    );
  }
}
```

---

## 项目结构

```
lib/
├── core/                    # 核心功能模块
│   ├── database/           # Drift 数据库 (tables.dart, database.dart)
│   ├── theme/              # 主题系统 (app_theme.dart)
│   └── router/             # 路由配置 (app_router.dart)
├── features/               # 功能模块 (按功能划分)
│   ├── today/
│   │   ├── data/           # 数据层 (repositories, datasources)
│   │   └── presentation/  # 表现层 (screens, widgets, providers)
│   ├── training/
│   │   ├── data/
│   │   └── presentation/
│   └── more/
│       ├── data/
│       └── presentation/
├── shared/                 # 共享组件
│   ├── widgets/            # 通用组件
│   └── utils/              # 工具函数
└── main.dart               # 应用入口
```

---

## 状态管理 (Riverpod)

### Provider 命名与组织

```dart
// 单一 provider
final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return ExerciseRepository(ref.watch(databaseProvider));
});

// 异步 provider
final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repo = ref.watch(exerciseRepositoryProvider);
  return repo.getAllExercises();
});

// 状态 notifier
class ExerciseNotifier extends StateNotifier<AsyncValue<List<Exercise>>> {
  ExerciseNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadExercises();
  }
  final ExerciseRepository _repository;
  
  Future<void> loadExercises() async { ... }
}

final exerciseNotifierProvider = StateNotifierProvider<ExerciseNotifier, AsyncValue<List<Exercise>>>((ref) {
  return ExerciseNotifier(ref.watch(exerciseRepositoryProvider));
});
```

---

## 数据库 (Drift)

### 表定义

```dart
class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get defaultSets => integer().withDefault(const Constant(3))();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}
```

### DAO 方法

```dart
@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<AppDatabase> with _$ExerciseDaoMixin {
  ExerciseDao(super.db);
  
  Future<List<Exercise>> getAllExercises() => select(exercises).get();
  
  Stream<List<Exercise>> watchAllExercises() => select(exercises).watch();
  
  Future<int> insertExercise(ExercisesCompanion exercise) => 
    into(exercises).insert(exercise);
}
```

---

## UI 开发 (Cupertino)

### 页面结构

```dart
import 'package:flutter/cupertino.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('今日'),
      ),
      child: SafeArea(
        child: // 页面内容
      ),
    );
  }
}
```

### 列表项

```dart
CupertinoListTile(
  title: const Text('训练项目'),
  trailing: const CupertinoListTileChevron(),
  onTap: () { },
)
```

---

## 错误处理

- **避免 print**: 使用 `debugPrint` 或日志框架
- **async/await**: 必须正确处理 Future 错误
- **空安全**: 避免 null 检查，使用 `?` 和 `!`

```dart
// Good
try {
  await repository.saveExercise(exercise);
} catch (e, stack) {
  debugPrint('保存失败: $e');
  rethrow;
}

// Bad
await repository.saveExercise(exercise);
```

---

## 注释规范

- **避免冗余注释**: 代码应自解释
- **必要注释**: 复杂逻辑、业务规则、API 契约
- **文档注释**: 公开 API 使用 `///` 文档注释

---

## 本地化

- **语言**: 简体中文 (zh-CN)
- **所有用户可见文本**: 使用中文
- **内部变量/方法**: 使用英文命名

---

## 依赖管理

在 `pubspec.yaml` 中添加依赖时:
1. 优先选择 Dart/Flutter 官方维护的包
2. 检查包的最后更新时间
3. 避免过度依赖

主要依赖:
- `flutter_riverpod`: 状态管理
- `drift`: SQLite 数据库
- `go_router`: 路由
- `phosphor_flutter`: 图标
- `intl`: 国际化

---

## 数据模型

### 表结构

| 表名 | 说明 | 主要字段 |
|------|------|----------|
| Exercises | 训练项目 | id, name, category, defaultSets, defaultReps, defaultWeight |
| WorkoutPlans | 健身计划 | id, name, cycleDays, isActive, startDate |
| PlanDays | 计划中的某天 | id, planId, dayIndex, isRestDay |
| DayExercise | 当天训练项目 | id, planDayId, exerciseId, targetSets, targetReps, targetWeight |
| DailyRecord | 每日记录 | id, date, planDayId, status (normal/rest/skipped), skipReason |
| ExerciseRecord | 训练记录 | id, dailyRecordId, exerciseId, actualSets, actualReps, actualWeight |
| AppSettings | 应用设置 | id, currentPlanId, currentCycleDay, lastActiveDate |

### 数据库初始化

数据库使用 LazyDatabase 延迟加载，存储在应用文档目录：

```dart
// lib/core/database/database_provider.dart
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'xworkout.db'));
    return NativeDatabase.createInBackground(file);
  });
}

final databaseProvider = AppDatabase();
```

---

## 功能模块

### 今日页面 (Today)
- 显示当天训练计划
- 支持开始训练、记录完成情况
- 休息日显示休息界面
- 偷懒/撤销偷懒功能

### 训练页面 (Training)
- 训练项目管理（增删改查）
- 健身计划管理
  - 创建计划（设置循环天数）
  - 配置每天的训练/休息
  - 为训练日添加训练项目
  - 激活/停用计划
- 历史记录入口

### 更多页面 (More)
- 历史记录入口
- 导出数据入口
- 设置
- 关于

---

## 开发注意事项

### 首次运行
```bash
# 1. 安装依赖
flutter pub get

# 2. 运行代码生成（重要！）
dart run build_runner build --delete-conflicting-outputs

# 3. 运行应用
flutter run
```

### 代码生成
Drift 数据库代码需要通过 build_runner 生成：
- `database.g.dart` - 由 tables.dart 和 database_provider.dart 自动生成
- 每次修改表结构后需要重新运行 build_runner

### Provider 组织
- 数据库 Provider: `databaseProvider` (单例)
- Repository Provider: 各功能模块的 repository provider
- 状态 Provider: 各功能模块的 notifier/provider

### 常见问题

**Q: 数据库报错 "Missing table"**
A: 运行 `dart run build_runner build --delete-conflicting-outputs` 生成数据库代码

**Q: Import 错误**
A: 检查是否正确导入了 `database_provider.dart` 而非 `database.dart`
