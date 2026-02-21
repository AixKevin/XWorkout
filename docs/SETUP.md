# XWorkout 开发环境配置指南

## 环境要求

| 项目 | 要求 |
|------|------|
| 操作系统 | Windows 10/11 或 macOS |
| 内存 | 至少 8GB (推荐 16GB) |
| 磁盘空间 | 至少 20GB 可用空间 |
| 网络 | 需要访问 GitHub 和 Pub.dev |

---

## 第一步：安装 Git

### Windows 用户

1. 打开浏览器访问：https://git-scm.com/download/win
2. 下载 "64-bit Git for Windows Setup"
3. 运行安装程序，基本保持默认设置
4. 安装完成后，在开始菜单找到 "Git Bash" 并打开

### macOS 用户

1. 打开终端 (Command + Space，输入 "Terminal")
2. 输入 `git --version`，如果已安装会显示版本号
3. 如果没有安装，Xcode 会提示安装

---

## 第二步：安装 Flutter SDK

### Windows 用户

#### 方法一：手动安装（推荐）

1. **创建安装目录**
   ```
   在 D: 盘根目录创建文件夹 Flutter（如果D盘空间不足可以用 C: 盘）
   路径建议：D:\flutter
   ```

2. **下载 Flutter SDK**
   - 打开 https://docs.flutter.dev/get-started/install/windows
   - 点击 "Latest stable release" 下载 flutter_windows_xxx_stable.zip
   - 将下载的文件解压到 D:\flutter

3. **配置环境变量**
   - 右键 "此电脑" → 属性
   - 点击 "高级系统设置"
   - 点击 "环境变量"
   - 在 "系统变量" 中找到 "Path"，双击编辑
   - 点击 "新建"，添加：`D:\flutter\bin`
   - 连续点击确定保存

4. **验证安装**
   打开 PowerShell 或 Git Bash，输入：
   ```bash
   flutter --version
   ```

#### 方法二：使用 git（推荐）

```bash
# 打开 PowerShell 或 Git Bash
cd D:\
git clone https://github.com/flutter/flutter.git -b stable
# 这可能需要10-30分钟
```

### macOS 用户

```bash
# 打开终端
cd ~/Development
git clone https://github.com/flutter/flutter.git -b stable

# 添加到 PATH
echo 'export PATH="$PATH:$HOME/Development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# 验证
flutter --version
```

---

## 第三步：安装 Android Studio

### 下载与安装

1. 访问 https://developer.android.com/studio
2. 下载 Windows 或 macOS 版本
3. 运行安装程序，基本保持默认设置
4. 安装完成后，启动 Android Studio

### 配置 Android SDK

1. 首次启动会提示安装 SDK
2. 点击 "Next" 安装推荐组件
3. 等待下载完成（可能需要20-30分钟）

### 设置环境变量（Windows）

如果 Flutter 找不到 Android SDK，手动设置：

```bash
# 在 PowerShell 中运行
flutter config --android-sdk "C:\Users\你的用户名\AppData\Local\Android\Sdk"
```

---

## 第四步：验证环境

### 运行以下命令检查

```bash
flutter doctor
```

应该看到类似输出：

```
Doctor summary (see the table below):
[✓] Flutter: Installed
[✓] Android toolchain: Installed
[✓] VS Code: Installed (optional)
[✓] Chrome: Not installed (optional)
[✓] Connected device: Available
```

---

## 第五步：克隆项目并运行

### 1. 克隆项目

```bash
# 打开 PowerShell 或 Git Bash
cd D:\
git clone https://github.com/你的用户名/XWorkout.git
cd XWorkout
```

### 2. 获取依赖

```bash
flutter pub get
```

### 3. 生成数据库代码

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. 运行应用

```bash
flutter run
```

---

## 常见问题解决

### 问题1：Android SDK 未找到

**解决方案：**
```bash
# 在 Flutter 安装目录运行
flutter config --android-sdk "C:\Users\用户名\AppData\Local\Android\Sdk"
```

### 问题2：Gradle 下载失败

**解决方案：**
1. 打开文件资源管理器
2. 进入 `C:\Users\用户名\.gradle`
3. 删除 wrapper 文件夹
4. 重新运行 `flutter run`

### 问题3：Android 模拟器无法启动

**解决方案：**
1. 打开 Android Studio
2. 点击 "More Actions" → "Virtual Device Manager"
3. 确保有可用设备
4. 点击播放按钮启动模拟器

### 问题4：手机无法连接

**解决方案：**
1. 打开手机 "开发者选项"
2. 启用 "USB 调试"
3. 连接电脑后，在手机上确认授权

---

## 快速安装脚本（Windows）

我创建了一个自动化脚本帮助你完成安装：

```powershell
# 将以下内容保存为 install-flutter.ps1

# 检查是否以管理员身份运行
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "请以管理员身份运行此脚本" -ForegroundColor Red
    exit 1
}

Write-Host "=== Flutter 环境自动配置脚本 ===" -ForegroundColor Cyan

# 1. 检查 Git
Write-Host "`n[1/5] 检查 Git..." -ForegroundColor Yellow
if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitVersion = git --version
    Write-Host "✓ Git 已安装: $gitVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Git 未安装，请先安装 Git" -ForegroundColor Red
    Write-Host "下载地址: https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

# 2. 检查 Flutter
Write-Host "`n[2/5] 检查 Flutter..." -ForegroundColor Yellow
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    $flutterVersion = flutter --version | Select-Object -First 1
    Write-Host "✓ Flutter 已安装: $flutterVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Flutter 未安装" -ForegroundColor Red
    Write-Host "请手动安装 Flutter SDK" -ForegroundColor Red
    exit 1
}

# 3. 检查 Android SDK
Write-Host "`n[3/5] 检查 Android SDK..." -ForegroundColor Yellow
$androidSDK = "$env:LOCALAPPDATA\Android\Sdk"
if (Test-Path $androidSDK) {
    Write-Host "✓ Android SDK 已安装" -ForegroundColor Green
} else {
    Write-Host "✗ Android SDK 未找到" -ForegroundColor Yellow
    Write-Host "请安装 Android Studio: https://developer.android.com/studio" -ForegroundColor Yellow
}

# 4. 运行 flutter doctor
Write-Host "`n[4/5] 运行 Flutter 诊断..." -ForegroundColor Yellow
flutter doctor

# 5. 检查项目
Write-Host "`n[5/5] 检查项目配置..." -ForegroundColor Yellow
$projectPath = Split-Path -Parent $MyInvocation.MyCommand.Path
if (Test-Path "$projectPath\pubspec.yaml") {
    Write-Host "✓ 项目文件存在" -ForegroundColor Green
    Write-Host "`n项目路径: $projectPath" -ForegroundColor Cyan
} else {
    Write-Host "✗ 项目文件不存在" -ForegroundColor Red
}

Write-Host "`n=== 配置完成 ===" -ForegroundColor Cyan
Write-Host "`n下一步操作：" -ForegroundColor White
Write-Host "1. cd $projectPath" -ForegroundColor White
Write-Host "2. flutter pub get" -ForegroundColor White
Write-Host "3. dart run build_runner build --delete-conflicting-outputs" -ForegroundColor White
Write-Host "4. flutter run" -ForegroundColor White

Read-Host "`n按回车键退出"
```

---

## 技术支持

如果遇到问题，可以：
1. 查看 Flutter 官方文档：https://docs.flutter.dev/
2. 在 GitHub 上提交 Issue
3. 在 Stack Overflow 搜索错误信息

---

## 快速启动命令汇总

```bash
# 首次运行
cd 项目目录
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run

# 后续开发
flutter run

# 如果修改了数据库
dart run build_runner build --delete-conflicting-outputs
flutter run

# 构建 APK
flutter build apk --debug
```

祝你开发愉快！🎉
