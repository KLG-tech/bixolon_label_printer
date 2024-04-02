import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bixolon_label_platform_interface.dart';

/// An implementation of [BixolonLabelPlatform] that uses method channels.
class MethodChannelBixolonLabel extends BixolonLabelPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bixolon_label');

  @override
  Future<bool?> connectIp(Map<String, dynamic> param) async {
    final result = await methodChannel.invokeMethod<bool>('connectIp', param);
    return result;
  }

  @override
  Future<String?> printText(Map<String, dynamic> param) async {
    final result = await methodChannel.invokeMethod<String>('printText', param);
    return result;
  }

  @override
  Future<String?> printImage(Map<String, dynamic> param) async {
    final result = await methodChannel.invokeMethod<String>('printImage', param);
    return result;
  }

  @override
  Future<bool?> isConnected() async {
    final result = await methodChannel.invokeMethod<bool>('isConnected');
    return result;
  }

  @override
  Future<bool?> disconnect() async {
    final result = await methodChannel.invokeMethod<bool>('disconnect');
    return result;
  }

  @override
  Future<bool?> connectUsb() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('connectUsb');
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> requestUsbPermissionDialog() async {
    try {
      await methodChannel.invokeMethod<void>("requestUsbPermission");
    } catch (e) {
      rethrow;
    }
  }
}
