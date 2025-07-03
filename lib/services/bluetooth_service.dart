import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as flutter_blue_plus;

/// 蓝牙设备管理类
class BluetoothDeviceManager {
  static final BluetoothDeviceManager _instance = BluetoothDeviceManager._internal();
  factory BluetoothDeviceManager() => _instance;
  BluetoothDeviceManager._internal();

  // 蓝牙状态
  flutter_blue_plus.BluetoothAdapterState _bluetoothState = flutter_blue_plus.BluetoothAdapterState.unknown;
  List<flutter_blue_plus.ScanResult> _scanResults = [];
  flutter_blue_plus.BluetoothDevice? _connectedDevice;
  flutter_blue_plus.BluetoothCharacteristic? _writeCharacteristic;

  // 获取蓝牙状态
  flutter_blue_plus.BluetoothAdapterState get bluetoothState => _bluetoothState;

  // 获取扫描结果
  List<flutter_blue_plus.ScanResult> get scanResults => _scanResults;

  // 获取已连接设备
  flutter_blue_plus.BluetoothDevice? get connectedDevice => _connectedDevice;

  /// 初始化蓝牙服务
  Future<void> initialize() async {
    // 监听蓝牙状态变化
    flutter_blue_plus.FlutterBluePlus.adapterState.listen((flutter_blue_plus.BluetoothAdapterState state) {
      _bluetoothState = state;
      print('蓝牙状态变化: $_bluetoothState');
    });
  }

  /// 检查蓝牙是否支持
  Future<bool> isSupportBle() async {
    return flutter_blue_plus.FlutterBluePlus.isSupported;
  }

  /// 检查蓝牙是否开启
  Future<bool> isBlueEnable() async {
    return _bluetoothState == flutter_blue_plus.BluetoothAdapterState.on;
  }

  /// 检查蓝牙权限
  Future<bool> checkPermission() async {
    if (await flutter_blue_plus.FlutterBluePlus.isSupported) {
      return true;
    }
    return false;
  }

  /// 扫描蓝牙设备
  Future<List<Map<String, dynamic>>> scanDevices() async {
    try {
      _scanResults.clear();
      // 开始扫描
      await flutter_blue_plus.FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
      // 监听扫描结果
      flutter_blue_plus.FlutterBluePlus.scanResults.listen((results) {
        _scanResults = results;
      });
      // 等待扫描完成
      await Future.delayed(const Duration(seconds: 10));
      await flutter_blue_plus.FlutterBluePlus.stopScan();
      // 转换为Map格式
      return _scanResults.map((result) {
        return {
          'name': result.device.platformName.isEmpty
              ? 'Unknown Device'
              : result.device.platformName,
          'identifier': result.device.remoteId.toString(),
          'rssi': result.rssi,
          'isConnectable': result.advertisementData.connectable,
        };
      }).toList();
    } catch (e) {
      print('扫描蓝牙设备失败: $e');
      return [];
    }
  }

  /// 连接蓝牙设备
  Future<bool> connectToDevice({
    required String identifier,
    required String serviceUUID,
    required String characterUUID,
  }) async {
    try {
      // 查找设备
      final device = _scanResults
          .firstWhere((result) => result.device.remoteId.toString() == identifier)
          .device;
      // 连接设备
      await device.connect(timeout: const Duration(seconds: 10));
      _connectedDevice = device;
      // 发现服务
      List<flutter_blue_plus.BluetoothService> services = await device.discoverServices();
      // 查找指定服务
      flutter_blue_plus.BluetoothService? targetService;
      for (flutter_blue_plus.BluetoothService service in services) {
        String serviceUuid = service.serviceUuid.str;
        if (serviceUuid.toUpperCase() == serviceUUID.toUpperCase()) {
          targetService = service;
          break;
        }
      }
      if (targetService == null) {
        throw Exception('未找到指定服务');
      }
      // 查找指定特征
      for (flutter_blue_plus.BluetoothCharacteristic characteristic in targetService.characteristics) {
        if (characteristic.characteristicUuid.str.toUpperCase() == characterUUID.toUpperCase()) {
          _writeCharacteristic = characteristic;
          break;
        }
      }
      if (_writeCharacteristic == null) {
        throw Exception('未找到指定特征');
      }
      return true;
    } catch (e) {
      print('连接蓝牙设备失败: $e');
      return false;
    }
  }

  /// 断开蓝牙设备
  Future<bool> disconnectDevice(String identifier) async {
    try {
      if (_connectedDevice != null) {
        await _connectedDevice!.disconnect();
        _connectedDevice = null;
        _writeCharacteristic = null;
        return true;
      }
      return false;
    } catch (e) {
      print('断开蓝牙设备失败: $e');
      return false;
    }
  }

  /// 发送数据到蓝牙设备
  Future<bool> sendData(List<int> data) async {
    try {
      if (_writeCharacteristic != null) {
        await _writeCharacteristic!.write(data);
        return true;
      }
      return false;
    } catch (e) {
      print('发送数据失败: $e');
      return false;
    }
  }

  /// 监听蓝牙设备数据
  Stream<List<int>>? listenToDeviceData() {
    if (_writeCharacteristic != null) {
      return _writeCharacteristic!.lastValueStream;
    }
    return null;
  }
}
