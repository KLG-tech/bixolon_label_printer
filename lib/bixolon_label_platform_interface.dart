import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bixolon_label_method_channel.dart';

abstract class BixolonLabelPlatform extends PlatformInterface {
  /// Constructs a BixolonLabelPlatform.
  BixolonLabelPlatform() : super(token: _token);

  static final Object _token = Object();

  static BixolonLabelPlatform _instance = MethodChannelBixolonLabel();

  /// The default instance of [BixolonLabelPlatform] to use.
  ///
  /// Defaults to [MethodChannelBixolonLabel].
  static BixolonLabelPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Bixgit solonLabelPlatform] when
  /// they register themselves.
  static set instance(BixolonLabelPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// example param = {
  /// "byteData": Uint8List,
  /// "horizontalPosition": 0, //default x position
  /// "verticalPosition": 0, // default y position
  /// "width": 300, //bixolon dx 220 using 66mm width
  /// "level": 50,
  /// "dithering": false
  /// }
  Future<String?> printImage(Map<String, dynamic> param) {
    throw UnimplementedError('printImage(param) has not been implemented.');
  }

  /// example param = {
  /// "text": "hello ges"
  /// }
  Future<String?> printText(Map<String, dynamic> param) {
    throw UnimplementedError('printText(param) has not been implemented.');
  }

  /// example param = {
  /// "ipAddress": "172.0.0.1"
  /// }
  Future<bool?> connectIp(Map<String, dynamic> param) {
    throw UnimplementedError('connectIp(param) has not been implemented.');
  }

  Future<bool?> isConnected() {
    throw UnimplementedError('isConnected() has not been implemented.');
  }

  Future<bool?> disconnect() {
    throw UnimplementedError('disconnect() has not been implemented.');
  }

  /// search usb device from bixolon sdk
  Future<bool?> connectUsb() {
    throw UnimplementedError('connectUsb() has not been implemented');
  }

  /// request usb permission dialog
  Future<void> requestUsbPermissionDialog() {
    throw UnimplementedError('requestUsbPermissionDialog() has not been implemented');
  }
}
