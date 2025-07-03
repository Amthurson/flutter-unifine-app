# 设备接口实现说明

本文档描述了Flutter项目中新增的设备接口实现，用于与Android原生代码保持一致。

## 新增功能

### 1. 应用启动功能

#### 新增文件
- `lib/services/app_launcher_service.dart` - 应用启动服务

#### 新增依赖
```yaml
app_launcher: ^1.0.0
package_info_plus: ^8.0.2
```

#### 实现的方法
- `launchApp` - 启动指定包名的应用

#### 使用示例
```javascript
// H5调用
window.flutter_bridge.call('launchApp', {
  packageName: 'com.example.app'
}, function(response) {
  console.log(response);
});
```

### 2. 蓝牙功能

#### 新增文件
- `lib/services/bluetooth_service.dart` - 蓝牙服务

#### 新增依赖
```yaml
flutter_blue_plus: ^1.31.15
```

#### 实现的方法
- `checkBtEnable` - 检查蓝牙是否可用
- `getBtDeviceList` - 获取蓝牙设备列表
- `connectToBtDevice` - 连接蓝牙设备
- `disconnectBtDevice` - 断开蓝牙设备

#### 使用示例
```javascript
// 检查蓝牙状态
window.flutter_bridge.call('checkBtEnable', {}, function(response) {
  console.log(response);
});

// 获取蓝牙设备列表
window.flutter_bridge.call('getBtDeviceList', {}, function(response) {
  console.log(response);
});

// 连接蓝牙设备
window.flutter_bridge.call('connectToBtDevice', {
  identifier: '00:11:22:33:44:55',
  serviceUUID: '0000ffe0-0000-1000-8000-00805f9b34fb',
  characterUUID: '0000ffe1-0000-1000-8000-00805f9b34fb'
}, function(response) {
  console.log(response);
});

// 断开蓝牙设备
window.flutter_bridge.call('disconnectBtDevice', {
  identifier: '00:11:22:33:44:55'
}, function(response) {
  console.log(response);
});
```

## 返回数据结构

### 成功响应格式
```json
{
  "status": "success",
  "msg": "操作成功",
  "data": {}
}
```

### 失败响应格式
```json
{
  "status": "fail",
  "msg": "错误信息",
  "data": {}
}
```

## 权限配置

### Android权限配置
在 `android/app/src/main/AndroidManifest.xml` 中添加：

```xml
<!-- 蓝牙权限 -->
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<!-- 蓝牙功能声明 -->
<uses-feature android:name="android.hardware.bluetooth_le" android:required="true" />
```

### iOS权限配置
在 `ios/Runner/Info.plist` 中添加：

```xml
<!-- 蓝牙权限描述 -->
<key>NSBluetoothAlwaysUsageDescription</key>
<string>此应用需要使用蓝牙功能来连接设备</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>此应用需要使用蓝牙功能来连接设备</string>
```

## 注意事项

1. **蓝牙功能**：需要设备支持BLE（Bluetooth Low Energy）
2. **权限处理**：应用首次使用蓝牙功能时会请求相关权限
3. **设备兼容性**：不同设备的蓝牙实现可能有差异
4. **错误处理**：所有方法都包含完整的错误处理机制

## 与Android代码的一致性

新增的方法与Android原生代码保持一致的返回格式：

- 成功时返回 `{"status": "success", "msg": "成功", "data": {}}`
- 失败时返回 `{"status": "fail", "msg": "错误信息", "data": {}}`

## 测试建议

1. 在真机上测试蓝牙功能
2. 测试不同Android版本的兼容性
3. 验证权限请求流程
4. 测试蓝牙设备的连接和断开
5. 验证应用启动功能

## 后续优化

1. 添加蓝牙数据监听功能
2. 实现蓝牙设备数据发送
3. 优化蓝牙连接稳定性
4. 添加更多应用管理功能 