import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'ble_constants.dart';
import 'ble_connection_state.dart';

class BleService {
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  QualifiedCharacteristic? rxCharacteristic;
  QualifiedCharacteristic? txCharacteristic;

  /// Scan devices
  Stream<DiscoveredDevice> scanDevices() {
    return _ble.scanForDevices(withServices: []);
  }

  /// Connect to device + track connection state
  void connect(
      String deviceId,
      BleConnectionState connectionState,
      ) {
    rxCharacteristic = QualifiedCharacteristic(
      deviceId: deviceId,
      serviceId: BleConstants.uartService,
      characteristicId: BleConstants.rxChar,
    );

    txCharacteristic = QualifiedCharacteristic(
      deviceId: deviceId,
      serviceId: BleConstants.uartService,
      characteristicId: BleConstants.txChar,
    );

    _ble.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    ).listen((update) {
      if (update.connectionState == DeviceConnectionState.connected) {
        connectionState.setConnected(true);
      } else if (update.connectionState ==
          DeviceConnectionState.disconnected) {
        connectionState.setConnected(false);
      }
    });
  }


  /// Enable notifications (TX)
  Stream<List<int>> subscribeToData() {
    return _ble.subscribeToCharacteristic(txCharacteristic!);
  }

  /// Write command (RX)
  Future<void> writeCommand(List<int> data) async {
    await _ble.writeCharacteristicWithResponse(
      rxCharacteristic!,
      value: data,
    );
  }
}
