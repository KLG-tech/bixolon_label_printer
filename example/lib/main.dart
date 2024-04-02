import 'package:flutter/material.dart';
import 'package:bixolon_label/bixolon_label.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Unknown';
  final _bixolonLabelPlugin = BixolonLabel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Text(_status),
            Expanded(child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(title: const Text("connect IP"), onTap: _onConnectIp),
                ListTile(title: const Text("connect usb"), onTap: _onConnectUsb),
                ListTile(title: const Text("disconnect"), onTap: _onDisconnect),
                ListTile(title: const Text("is connected"), onTap: _onIsConnected),
                ListTile(title: const Text("print Text"), onTap: _onPrintText),
                ListTile(title: const Text("print Image"), onTap: _onPrintImage),
                ListTile(title: const Text("request usb permission"), onTap: _onRequestUsbPermission),
              ],
            ))
          ],
        ),
      ),
    );
  }

  void _onConnectIp() async {
    final param = {"ipAddress" : "172.0.0.0"};
    try {
      final result = await _bixolonLabelPlugin.connectIp(param);
      _status = "is success connected to ${param['ipAddress']}? $result";
    } catch (e) {
      _status = "failed to connect to ${param['ipAddress']}";
    } finally {
      setState(() {});
    }
  }

  void _onConnectUsb() async {
    try {
      final result = await _bixolonLabelPlugin.connectUsb();
      _status = "is success connected to? $result";
    } catch (e) {
      _status = "failed to connect to";
    } finally {
      setState(() {});
    }
  }

  void _onDisconnect() async {
    try {
      final result = await _bixolonLabelPlugin.disconnect();
      _status = "is success disconnected? $result";
    } catch (e) {
      _status = "failed to disconnect";
    } finally {
      setState(() {});
    }
  }

  void _onIsConnected() async {
    try {
      final result = await _bixolonLabelPlugin.isConnected();
      _status = "is connected? $result";
    } catch (e) {
      _status = e.toString();
    } finally {
      setState(() {});
    }
  }

  void _onPrintText() async {
    final param = {"text": "Test Print Ges"};
    try {
      final result = await _bixolonLabelPlugin.printText(param);
      _status = "$result";
    } catch (e) {
      _status = "$e";
    } finally {
      setState(() {});
    }
  }

  void _onPrintImage() async {
    final ByteData bytes = await rootBundle.load('assets/images/phoenix_icon.png');
    final Uint8List list = bytes.buffer.asUint8List();
    final param = {
      "byteData": list,
      "horizontalPosition": 0,
      "verticalPosition": 0,
      "width": 320,
      "level": 50,
      "dithering": true
    };
    try {
      final result = await _bixolonLabelPlugin.printImage(param);
      _status = "$result";
    } catch (e) {
      _status = "$e";
    } finally {
      setState(() {});
    }
  }

  void _onRequestUsbPermission() async {
    try {
      await _bixolonLabelPlugin.requestUsbPermissionDialog();
    } catch (e) {
      _status = "$e";
    } finally {
      setState(() {});
    }
  }
}
