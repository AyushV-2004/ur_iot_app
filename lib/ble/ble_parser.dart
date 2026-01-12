import 'ble_data_provider.dart';
import '../firebase/firebase_service.dart';
import '../firebase/sensor_model.dart';

class BleParser {
  static void parse(List<int> data, BleDataProvider provider, {String? mac}) {

    if (data.length < 64) {
      print("⚠ Packet too short (${data.length}/64) → skipping");
      return;
    }

    final hex = _toHex(data);
    print("🧾 HEX RAW PACKET (64 bytes): $hex");

    if (data[1] != 0x02) {
      print("⚠ Not a sensor data packet");
      return;
    }

    final pm25 = data[10] + (data[11] << 8);
    final pm10 = data[12] + (data[13] << 8);
    final pm1  = data[14] + (data[15] << 8);
    final battery = data[16];
    final noise = data[17];
    final temperature = data[18] + data[19] / 10;
    final humidity = data[20] + data[21] / 10;

    // Update UI provider
    provider.update(
      pm25: pm25.toDouble(),
      pm10: pm10.toDouble(),
      pm1: pm1.toDouble(),
      battery: battery.toDouble(),
      noise: noise.toDouble(),
      temperature: temperature,
      humidity: humidity,
    );



    final reading = SensorReading(
      pm25: pm25.toDouble(),
      pm10: pm10.toDouble(),
      pm1: pm1.toDouble(),
      temperature: temperature,
      humidity: humidity,
      noise: noise,
      battery: battery.toDouble(),
      timestamp: DateTime.now(),
    );



    if (mac != null) {
      FirebaseService().saveReading(mac, reading.toJson());
      print("✅ Saved reading for $mac");
    }
  }

  static String _toHex(List<int> bytes) {
    return bytes
        .take(64)
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join(' ');
  }
}