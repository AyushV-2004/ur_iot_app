import 'ble_data_provider.dart';
class BleParser {
  static void parse(
      List<int> data,
      BleDataProvider provider,
      ) {
    if (data.isEmpty || data[1] != 0x02) return;

    final pm25 = data[10] + (data[11] << 8);
    final pm10 = data[12] + (data[13] << 8);
    final noise = data[17];
    final temp = data[18] + data[19] / 10;
    final humidity = data[20] + data[21] / 10;

    provider.update(
      pm25: pm25.toDouble(),
      pm10: pm10.toDouble(),
      noise: noise.toDouble(),
      temperature: temp,
      humidity: humidity,
    );
  }
}
