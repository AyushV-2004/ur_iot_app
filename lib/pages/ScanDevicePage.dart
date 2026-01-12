import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

import '../ble/ble_service.dart';
import 'DeviceDashboardPage.dart';

class ScanDevicePage extends StatefulWidget {
  const ScanDevicePage({super.key});

  @override
  State<ScanDevicePage> createState() => _ScanDevicePageState();
}

class _ScanDevicePageState extends State<ScanDevicePage> {
  final BleService bleService = BleService();
  final List<DiscoveredDevice> devices = [];
  StreamSubscription<DiscoveredDevice>? _scanSub;

  bool isScanning = false;
  String statusText = "Checking permissions...";

  @override
  void initState() {
    super.initState();
    _checkPermissionAndScan();
  }

  Future<void> _checkPermissionAndScan() async {
    final statuses = await [
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    final locationGranted = statuses[Permission.location]?.isGranted ?? false;
    final scanGranted = statuses[Permission.bluetoothScan]?.isGranted ?? false;

    if (locationGranted && scanGranted) {
      setState(() {
        statusText = "Scanning for devices...";
      });
      _startScan();
    } else {
      setState(() {
        statusText =
        "Bluetooth and Location permissions are required for BLE scanning";
      });
    }
  }

  void _startScan() {
    isScanning = true;
    print("🔍 BLE scan started");

    _scanSub = bleService.scanDevices().listen((device) {
      print("📡 Discovered device: ${device.name} (${device.id})");

      if (device.name.startsWith("UrHealth_")) {
        if (!devices.any((d) => d.id == device.id)) {
          print("✅ Added AQI device: ${device.name}");
          setState(() {
            devices.add(device);
          });
        }
      }
    }, onError: (error) {
      print("❌ Scan error: $error");
      setState(() {
        statusText = "Scan error: $error";
        isScanning = false;
      });
    });
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan AQI Device")),
      body: devices.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isScanning) const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(statusText, textAlign: TextAlign.center),
          ],
        ),
      )
          : ListView.builder(
        itemCount: devices.length,
        itemBuilder: (_, i) {
          final device = devices[i];
          return ListTile(
            leading: const Icon(Icons.bluetooth),
            title: Text(device.name),
            subtitle: Text(device.id),
            onTap: () {
              _scanSub?.cancel();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeviceDashboardPage(device),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
