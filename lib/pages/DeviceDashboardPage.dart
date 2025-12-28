import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '../ble/ble_service.dart';
import '../ble/ble_parser.dart';
import '../ble/ble_connection_state.dart';
import '../ble/ble_data_provider.dart';

class DeviceDashboardPage extends StatefulWidget {
  final DiscoveredDevice device;
  DeviceDashboardPage(this.device);

  @override
  _DeviceDashboardPageState createState() => _DeviceDashboardPageState();
}

class _DeviceDashboardPageState extends State<DeviceDashboardPage> {
  final BleService bleService = BleService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bleState =
      Provider.of<BleConnectionState>(context, listen: false);
      final bleData =
      Provider.of<BleDataProvider>(context, listen: false);

      // Connect to device
      bleService.connect(widget.device.id, bleState);

      // Subscribe to BLE notifications
      bleService.subscribeToData().listen((data) {
        BleParser.parse(data, bleData);
      });
    });
  }


  void getLastData() {
    bleService.writeCommand([0x7E, 0x02, 0x00, 0x00]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Device Dashboard")),
      body: Center(
        child: ElevatedButton(
          onPressed: getLastData,
          child: const Text("Get Last Data"),
        ),
      ),
    );
  }
}
