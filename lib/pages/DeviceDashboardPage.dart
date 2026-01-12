// import 'package:flutter/material.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:provider/provider.dart';
//
// import '../ble/ble_service.dart';
// import '../ble/ble_parser.dart';
// import '../ble/ble_connection_state.dart';
// import '../ble/ble_data_provider.dart';
// import '../ble/ble_device_provider.dart';
//
// class DeviceDashboardPage extends StatefulWidget {
//   final DiscoveredDevice device;
//
//   const DeviceDashboardPage(this.device, {super.key});
//
//   @override
//   State<DeviceDashboardPage> createState() => _DeviceDashboardPageState();
// }
//
// class _DeviceDashboardPageState extends State<DeviceDashboardPage> {
//   final BleService bleService = BleService();
//
//   @override
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final bleState = Provider.of<BleConnectionState>(context, listen: false);
//       final bleData = Provider.of<BleDataProvider>(context, listen: false);
//       final deviceProvider = Provider.of<BleDeviceProvider>(context, listen: false);
//
//       deviceProvider.setMac(widget.device.id);
//
//       bleService.connect(widget.device.id, bleState);
//
//       // Listen for connection becoming true
//       bleState.addListener(() {
//         if (bleState.isConnected) {
//           print("🟦 Requesting last sensor data...");
//           bleService.writeCommand([0x7E, 0x09, 0x00, 0x00]);
//         }
//       });
//
//       bleService.subscribeToData().listen((data) {
//         final mac = deviceProvider.mac;
//         print("📥 Received BLE Data from $mac: $data");
//         BleParser.parse(data, bleData, mac: mac);
//       });
//     });
//   }
//
//
//   void requestLastData() {
//     print("📤 Requesting last sensor data...");
//     bleService.writeCommand([0x7E, 0x02, 0x00, 0x00]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Device Dashboard")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: requestLastData,
//           child: const Text("Get Last Sensor Data"),
//         ),
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '../ble/ble_service.dart';
import '../ble/ble_parser.dart';
import '../ble/ble_connection_state.dart';
import '../ble/ble_data_provider.dart';
import '../ble/ble_device_provider.dart';

class DeviceDashboardPage extends StatefulWidget {
  final DiscoveredDevice device;

  const DeviceDashboardPage(this.device, {super.key});

  @override
  State<DeviceDashboardPage> createState() => _DeviceDashboardPageState();
}

class _DeviceDashboardPageState extends State<DeviceDashboardPage> {
  final BleService bleService = BleService();
  late BleConnectionState bleState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bleState = Provider.of<BleConnectionState>(context, listen: false);
      final bleData = Provider.of<BleDataProvider>(context, listen: false);
      final deviceProvider =
      Provider.of<BleDeviceProvider>(context, listen: false);

      deviceProvider.setMac(widget.device.id);

      print("🔗 Connecting to ${widget.device.id}");
      bleService.connect(widget.device.id, bleState);

      // Listen for connection state changes
      bleState.addListener(_onConnectionChanged);

      // Subscribe to notifications
      bleService.subscribeToData().listen((data) {
        final mac = deviceProvider.mac;
        print("📥 Received BLE Data from $mac: $data");
        BleParser.parse(data, bleData, mac: mac);
      });
    });
  }

  void _onConnectionChanged() {
    if (bleState.isConnected) {
      print("🟦 Device connected — requesting last sensor data...");
      bleService.writeCommand([0x7E, 0x09, 0x00, 0x00]);
    }
  }

  void requestLastData() {
    if (!bleState.isConnected) {
      print("⏳ Not connected yet — cannot request data");
      return;
    }

    print("📤 Manually requesting last sensor data...");
    bleService.writeCommand([0x7E, 0x02, 0x00, 0x00]);
  }

  @override
  void dispose() {
    bleState.removeListener(_onConnectionChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Device Dashboard")),
      body: Center(
        child: ElevatedButton(
          onPressed: requestLastData,
          child: const Text("Get Last Sensor Data"),
        ),
      ),
    );
  }
}
