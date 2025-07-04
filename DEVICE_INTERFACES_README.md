# 设备接口实现说明

本文档描述了Flutter项目中新增的设备接口实现，包括蓝牙功能和应用启动功能，用于与Android原生代码保持一致。

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
window.WebViewJavascriptBridge.callHandler('launchApp', {
  packageName: 'com.example.app'
}, function(response) {
  console.log(response);
});
```

#### Flutter端实现
```dart
class _LaunchAppHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final entity = data is String ? jsonDecode(data) : data;
      final packageName = entity['packageName'] as String?;

      if (packageName == null || packageName.isEmpty) {
        callback(BridgeResponse.error(msg: '包名不能为空').toJsonString());
        return;
      }

      final result = await AppLauncherService.launchApp(packageName);
      
      if (result) {
        callback(BridgeResponse.success(msg: '应用启动成功').toJsonString());
      } else {
        callback(BridgeResponse.error(msg: '应用启动失败').toJsonString());
      }
    } catch (e) {
      callback(BridgeResponse.error(msg: '启动应用异常: $e').toJsonString());
    }
  }
}
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
window.WebViewJavascriptBridge.callHandler('checkBtEnable', {}, function(response) {
  console.log(response);
});

// 获取蓝牙设备列表
window.WebViewJavascriptBridge.callHandler('getBtDeviceList', {}, function(response) {
  console.log(response);
});

// 连接蓝牙设备
window.WebViewJavascriptBridge.callHandler('connectToBtDevice', {
  identifier: '00:11:22:33:44:55',
  serviceUUID: '0000ffe0-0000-1000-8000-00805f9b34fb',
  characterUUID: '0000ffe1-0000-1000-8000-00805f9b34fb'
}, function(response) {
  console.log(response);
});

// 断开蓝牙设备
window.WebViewJavascriptBridge.callHandler('disconnectBtDevice', {
  identifier: '00:11:22:33:44:55'
}, function(response) {
  console.log(response);
});
```

#### Flutter端实现示例
```dart
class _CheckBtEnableHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final isEnabled = await BluetoothService.checkBtEnable();
      callback(BridgeResponse.success(
        data: {'isEnabled': isEnabled}
      ).toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '检查蓝牙状态失败: $e').toJsonString());
    }
  }
}

class _GetBtDeviceListHandler implements BridgeHandler {
  @override
  void call(dynamic data, Function(String) callback) async {
    try {
      final devices = await BluetoothService.getBtDeviceList();
      callback(BridgeResponse.success(
        data: {'devices': devices}
      ).toJsonString());
    } catch (e) {
      callback(BridgeResponse.error(msg: '获取蓝牙设备列表失败: $e').toJsonString());
    }
  }
}
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

## 服务实现

### 1. 应用启动服务

```dart
class AppLauncherService {
  /// 启动指定包名的应用
  static Future<bool> launchApp(String packageName) async {
    try {
      final result = await AppLauncher.launchApp(
        androidApplicationId: packageName,
        iosUrlScheme: packageName,
      );
      return result;
    } catch (e) {
      print('启动应用失败: $e');
      return false;
    }
  }
}
```

### 2. 蓝牙服务

```dart
class BluetoothService {
  /// 检查蓝牙是否可用
  static Future<bool> checkBtEnable() async {
    try {
      final state = await FlutterBluePlus.adapterState.first;
      return state == BluetoothAdapterState.on;
    } catch (e) {
      print('检查蓝牙状态失败: $e');
      return false;
    }
  }

  /// 获取蓝牙设备列表
  static Future<List<Map<String, dynamic>>> getBtDeviceList() async {
    try {
      final devices = await FlutterBluePlus.systemDevices;
      return devices.map((device) => {
        'identifier': device.remoteId.toString(),
        'name': device.platformName,
        'rssi': device.rssi,
      }).toList();
    } catch (e) {
      print('获取蓝牙设备列表失败: $e');
      return [];
    }
  }

  /// 连接蓝牙设备
  static Future<bool> connectToBtDevice(String identifier, String serviceUUID, String characterUUID) async {
    try {
      final device = FlutterBluePlus.systemDevices.firstWhere(
        (d) => d.remoteId.toString() == identifier,
      );
      
      await device.connect();
      final services = await device.discoverServices();
      
      for (final service in services) {
        if (service.uuid.toString() == serviceUUID) {
          final characteristics = service.characteristics;
          for (final characteristic in characteristics) {
            if (characteristic.uuid.toString() == characterUUID) {
              // 连接成功
              return true;
            }
          }
        }
      }
      
      return false;
    } catch (e) {
      print('连接蓝牙设备失败: $e');
      return false;
    }
  }

  /// 断开蓝牙设备
  static Future<bool> disconnectBtDevice(String identifier) async {
    try {
      final device = FlutterBluePlus.systemDevices.firstWhere(
        (d) => d.remoteId.toString() == identifier,
      );
      
      await device.disconnect();
      return true;
    } catch (e) {
      print('断开蓝牙设备失败: $e');
      return false;
    }
  }
}
```

## 注意事项

1. **蓝牙功能**：需要设备支持BLE（Bluetooth Low Energy）
2. **权限处理**：应用首次使用蓝牙功能时会请求相关权限
3. **设备兼容性**：不同设备的蓝牙实现可能有差异
4. **错误处理**：所有方法都包含完整的错误处理机制
5. **应用启动**：某些应用可能无法通过包名启动，需要特殊处理

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
6. 测试各种异常情况的处理

## 后续优化

1. 添加蓝牙数据监听功能
2. 实现蓝牙设备数据发送
3. 优化蓝牙连接稳定性
4. 添加更多应用管理功能
5. 支持更多设备接口功能 