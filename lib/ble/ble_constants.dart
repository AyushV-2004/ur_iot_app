import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleConstants {
  static final Uuid uartService =
  Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e");

  static final Uuid rxChar =
  Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e");

  static final Uuid txChar =
  Uuid.parse("6e400003-b5a3-f393-e0a9-e50e24dcca9e");
}
