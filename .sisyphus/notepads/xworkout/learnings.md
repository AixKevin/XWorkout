# XWorkout 开发笔记

## 项目约定
- 语言: 简体中文 (zh-cn)
- UI风格: Apple/Cupertino风格
- 状态管理: Riverpod
- 数据库: Drift (SQLite)

## 命名规范
- 文件名: snake_case
- 类名: PascalCase
- 变量/方法: camelCase
- 常量: camelCase (Dart风格)

## 目录结构
```
lib/
├── core/           # 核心功能
│   ├── database/   # 数据库
│   ├── theme/      # 主题
│   └── router/     # 路由
├── features/       # 功能模块
│   ├── today/      # 今日页面
│   ├── training/   # 训练管理
│   └── more/       # 更多
├── shared/         # 共享组件
└── main.dart
```

## 决策记录
(待记录)

## 发现

### 架构模式
- 使用 `features` 目录进行垂直切分，每个特性模块包含 `presentation`、`data` 等层级。
- 使用 `core` 目录存放全局共享的模块，如 `theme`、`router`。
- 使用 `shared` 目录存放跨特性共享的组件和工具。

### 路由管理
- 采用了 `go_router` 的 `StatefulShellRoute` 实现带底部导航栏的嵌套路由，保持了 Tab 切换时的状态。
- 路由结构清晰，主入口配置在 `lib/core/router/app_router.dart`。

### 主题定制
- 针对 Apple 风格，采用了 `CupertinoApp` 和 `CupertinoThemeData`。
- 预留了深色模式的配置，通过 `AppTheme` 类统一管理颜色。

### 状态管理
- 引入了 `flutter_riverpod` 作为状态管理方案，并在 `main.dart` 中注入了 `ProviderScope`。

### 本地化
- 配置了 `flutter_localizations`，支持中文环境 (`zh_CN`)。
