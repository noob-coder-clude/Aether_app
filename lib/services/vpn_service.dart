import 'dart:async';
import 'package:flutter/services.dart';
import '../models/aether_config.dart';

class VpnServiceController {
  static const MethodChannel _vpnChannel = MethodChannel('com.cluvex.aether/vpn');
  static const MethodChannel _coreChannel = MethodChannel('com.cluvex.aether/core');
  static const EventChannel _logsChannel = EventChannel('com.cluvex.aether/logs');

  StreamSubscription? _logSubscription;
  final List<String> _logs = [];

  List<String> get logs => List.unmodifiable(_logs);

  void listenLogs(Function(String) onLine) {
    _logSubscription?.cancel();
    _logSubscription = _logsChannel.receiveBroadcastStream().listen((dynamic event) {
      if (event is String) {
        _logs.add(event);
        if (_logs.length > 500) _logs.removeAt(0);
        onLine(event);
      }
    });
  }

  Future<bool> prepareVpn() async {
    try {
      final bool? isPrepared = await _vpnChannel.invokeMethod('prepareVpn');
      return isPrepared ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> startTunnel(AetherConfig config) async {
    try {
      _logs.clear();
      if (config.isSystemVpn) {
        await _vpnChannel.invokeMethod('startVpn');
      }
      final bool? success = await _coreChannel.invokeMethod('startCore', config.toMap());
      return success ?? false;
    } catch (e) {
      _logs.add('[Error] Failed to start tunnel: $e');
      return false;
    }
  }

  Future<bool> stopTunnel() async {
    try {
      await _coreChannel.invokeMethod('stopCore');
      await _vpnChannel.invokeMethod('stopVpn');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isCoreRunning() async {
    try {
      final bool? running = await _coreChannel.invokeMethod('isCoreRunning');
      return running ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<String> getAbi() async {
    try {
      final String? abi = await _coreChannel.invokeMethod('getAbi');
      return abi ?? 'arm64';
    } catch (e) {
      return 'arm64';
    }
  }

  Future<bool> updateBinaryBytes(Uint8List bytes) async {
    try {
      final bool? success = await _coreChannel.invokeMethod('updateBinary', {'bytes': bytes});
      return success ?? false;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _logSubscription?.cancel();
  }
}
