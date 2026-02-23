# Android 无线调试配置指南

本文档详细介绍如何使用实体手机进行无线调试，解决模拟器兼容性问题。

---

## 前提条件

| 要求 | 说明 |
|------|------|
| 手机系统 | Android 11+ (推荐) |
| 电脑 | Windows/macOS/Linux |
| 网络 | 手机和电脑连接同一 Wi-Fi |

---

## 方法一：传统有线转无线（推荐）

### 步骤 1：开启开发者选项

1. 手机设置 → 关于手机
2. 连续点击「版本号」7 次，开启开发者模式
3. 返回设置 → 开发者选项

### 步骤 2：开启 USB 调试

1. 在开发者选项中，启用「USB 调试」
2. 用数据线连接手机和电脑

### 步骤 3：设置无线调试端口

```bash
# 查看设备连接
adb devices

# 设置 TCP/IP 端口 (5555 为默认端口)
adb tcpip 5555
```

### 步骤 4：获取手机 IP 地址

**方法一**：设置 → 关于手机 → IP 地址

**方法二**（更准确）：
```bash
adb shell ip addr show wlan0
```

### 步骤 5：无线连接

```bash
# 连接手机 (替换为你的 IP 地址)
adb connect 192.168.1.x:5555

# 验证连接
adb devices
```

成功后会看到：
```
List of devices attached
192.168.1.x:5555    device
```

### 步骤 6：拔掉数据线

现在可以拔掉数据线，通过 Wi-Fi 无线调试了！

---

## 方法二：Android 11+ 配对码方式

适用于 Android 11 及以上系统，更安全。

### 步骤 1：开启开发者选项和无线调试

1. 设置 → 关于手机 → 版本号（点击 7 次）
2. 设置 → 开发者选项 → 启用「USB 调试」
3. 启用「无线调试」→ 点击进入

### 步骤 2：使用配对码配对

1. 在手机「无线调试」页面，点击「使用配对码配对设备」
2. 记下 IP 地址、端口号、配对码

### 步骤 3：电脑执行配对

```bash
# 配对命令
adb pair 192.168.1.x:端口号

# 输入配对码
Enter pairing code: xxxxxx
```

### 步骤 4：连接

```bash
# 连接设备
adb connect 192.168.1.x:端口号
```

---

## 方法三：VS Code 无线调试

### 使用 ADB Interface 插件

1. 在 VS Code 插件市场安装「ADB Interface」
2. 数据线连接手机
3. 打开命令面板 (`Ctrl + Shift + P`)
4. 执行：
   - `ADB: Disconnect from any devices`
   - `ADB: Reset connected devices port to :5555`
   - `ADB: Connect to device IP` → 输入手机 IP

---

## 运行 Flutter 项目

连接成功后，直接运行：

```bash
# 查看设备列表
flutter devices

# 运行调试
flutter run
```

---

## 常见问题

### Q1: adb 命令找不到

**解决**：配置环境变量

Windows 添加 Path：
```
E:\code\android\SDK\platform-tools
```

### Q2: 连接失败

**解决**：
1. 确保手机和电脑在同一 Wi-Fi
2. 检查防火墙是否阻止
3. 尝试重新连接：
```bash
adb disconnect
adb connect 192.168.1.x:5555
```

### Q3: 设备离线

**解决**：
```bash
adb kill-server
adb start-server
adb connect 192.168.1.x:5555
```

### Q4: 每次都需要重新连接？

**解决**：首次连接后，只要在同一网络下，下次直接运行 `flutter run` 即可。

---

## 快速命令汇总

```bash
# 首次设置
adb tcpip 5555
adb connect 192.168.1.x:5555

# 后续使用
adb connect 192.168.1.x:5555
flutter run

# 查看设备
adb devices
flutter devices

# 断开连接
adb disconnect
```

---

## 拓展：多设备同时调试

```bash
# 查看所有设备
adb devices

# 指定设备运行
flutter run -d 192.168.1.x:5555
```
