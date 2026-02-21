# Flutter 开发环境配置指南

本文档详细介绍如何在本地配置 Flutter 开发环境并运行 XWorkout 项目。

## 环境要求

| 项目 | 要求 |
|------|------|
| 操作系统 | Windows 10/11, macOS, Linux |
| 内存 | 至少 8GB (推荐 16GB) |
| 磁盘空间 | 至少 20GB 可用空间 |

---

## 第一步：安装 Git

### Windows
1. 下载 Git：https://git-scm.com/download/win
2. 安装时保持默认设置
3. 安装完成后，在开始菜单找到 "Git Bash"

### macOS
终端输入 `git --version`，如未安装会提示安装

---

## 第二步：安装 Flutter SDK

### Windows

#### 方法一：手动安装（推荐）

1. **创建安装目录**（建议 D:\flutter）
2. **下载 Flutter SDK**
   - 访问：https://docs.flutter.dev/get-started/install/windows
   - 下载最新稳定版
3. **解压**到 D:\flutter
4. **配置环境变量**
   - 右键 "此电脑" → 属性 → 高级系统设置 → 环境变量
   - 在 Path 中添加：`D:\flutter\bin`

#### 方法二：使用 Git

```bash
cd D:\
git clone https://github.com/flutter/flutter.git -b stable
```

### macOS / Linux

```bash
cd ~/Development
git clone https://github.com/flutter/flutter.git -b stable
echo 'export PATH="$PATH:$HOME/Development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

---

## 第三步：安装 Android Studio

1. 下载：https://developer.android.com/studio
2. 安装并启动
3. 首次启动会提示安装 SDK组件
4. 等待下载完成（约 20-30 分钟）

### 配置环境变量（如需要）

```bash
flutter config --android-sdk "C:\Users\你的用户名\AppData\Local\Android\Sdk"
```

---

## 第四步：验证环境

```bash
flutter doctor
```

应该看到：

```
✓ Flutter: Installed
✓ Android toolchain: Installed
```

---

## 第五步：克隆项目

```bash
# 进入工作目录
cd D:\Dev

# 克隆项目
git clone https://github.com/AixKevin/XWorkout.git

# 进入项目目录
cd XWorkout
```

---

## 第六步：安装依赖

```bash
flutter pub get
```

这会下载项目所需的所有依赖包。

---

## 第七步：生成数据库代码

**这是关键步骤！**

```bash
dart run build_runner build --delete-conflicting-outputs
```

这个命令会：
- 读取 `tables.dart` 中的表定义
- 生成 `database.g.dart` 文件
- 创建数据库访问类

**注意**：每次修改数据库表结构后都需要重新运行此命令。

---

## 第八步：运行应用

### 方法一：使用 VS Code

1. 用 VS Code 打开项目目录
2. 按 `F5` 或点击右上角 "Run" 按钮

### 方法二：使用命令行

```bash
flutter run
```

### 方法三：连接真机调试

1. 开启手机的 "开发者选项" 和 "USB 调试"
2. 连接电脑，在手机上确认授权
3. 运行 `flutter devices` 查看设备列表
4. 运行 `flutter run -d 设备ID`

---

## 第九步：构建 APK

### 调试版（推荐开发使用）

```bash
flutter build apk --debug
```

APK 位置：`build/app/outputs/flutter-apk/app-debug.apk`

### 发布版

```bash
flutter build apk --release
```

APK 位置：`build/app/outputs/flutter-apk/app-release.apk`

---

## 常见问题

### Q1: Flutter 命令找不到

**解决**：确认环境变量配置正确
```bash
# 检查 Flutter 是否安装成功
flutter --version
```

### Q2: Android SDK 未找到

**解决**：
```bash
flutter config --android-sdk "你的SDK路径"
```

### Q3: Gradle 下载失败

**解决**：
```bash
# 删除 Gradle 缓存
rm -rf ~/.gradle/caches
# 重新构建
flutter build apk --debug
```

### Q4: 代码报错 Missing table

**解决**：重新运行代码生成
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 常用命令汇总

```bash
# 安装依赖
flutter pub get

# 代码生成（修改数据库后必须运行）
dart run build_runner build --delete-conflicting-outputs

# 运行应用
flutter run

# 构建调试 APK
flutter build apk --debug

# 构建发布 APK
flutter build apk --release

# 代码检查
flutter analyze

# 格式化代码
flutter format .
```

---

## 项目结构说明

```
lib/
├── core/                    # 核心功能
│   ├── database/           # 数据库层
│   ├── router/            # 路由配置
│   └── theme/             # 主题样式
├── features/               # 功能模块
│   ├── today/            # 今日页面
│   ├── training/          # 训练管理
│   └── more/             # 更多设置
├── shared/                # 共享组件
└── main.dart              # 应用入口
```

---

## 下一步

1. 按照本指南配置好环境
2. 运行 `flutter run` 确认项目可以启动
3. 开始开发！

祝你开发愉快！🎉
