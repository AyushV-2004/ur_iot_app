import 'package:flutter/material.dart';

class BleConnectionState extends ChangeNotifier {
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void setConnected(bool value) {
    _isConnected = value;
    notifyListeners();
  }
}
