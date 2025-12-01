import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:ur_iot_app/pages/ChatBotPage.dart';
import 'package:ur_iot_app/pages/ProfilePage.dart';
import 'package:ur_iot_app/pages/SettingsPage.dart';
import 'package:ur_iot_app/pages/StatPage.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      _navKeys[index].currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  Widget _buildNavTab(GlobalKey<NavigatorState> key, Widget child) {
    return Navigator(
      key: key,
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildNavTab(_navKeys[0], const HomeContent()),
          _buildNavTab(_navKeys[1], const ProfilePage()),
          _buildNavTab(_navKeys[2], const SettingsPage()),
        ],
      ),

      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 65,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.home_rounded,
                    size: 28,
                    color: _selectedIndex == 0
                        ? const Color(0xFF1B52D7)
                        : Colors.black87,
                  ),
                  onPressed: () => _onItemTapped(0),
                ),
                IconButton(
                  icon: Icon(
                    Icons.person_rounded,
                    size: 28,
                    color: _selectedIndex == 1
                        ? const Color(0xFF1B52D7)
                        : Colors.black87,
                  ),
                  onPressed: () => _onItemTapped(1),
                ),
                IconButton(
                  icon: Icon(
                    Icons.settings_rounded,
                    size: 28,
                    color: _selectedIndex == 2
                        ? const Color(0xFF1B52D7)
                        : Colors.black87,
                  ),
                  onPressed: () => _onItemTapped(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ------------------------------------------------------
// HOME CONTENT WITH LIVE SENSOR DATA + GRID CARD LAYOUT
// ------------------------------------------------------
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final Random _random = Random();
  Timer? _timer;
  late Box box;

  double temperature = 27.0;
  double humidity = 55.0;
  double pm25 = 22.0;
  double pm10 = 35.0;
  double uvIndex = 5.0;
  double noise = 60.0;

  List<double> tempHistory = [];
  List<double> humidityHistory = [];
  List<double> pm25History = [];
  List<double> pm10History = [];
  List<double> uvHistory = [];
  List<double> noiseHistory = [];

  double _smoothChange(double current, double min, double max, {double variation = 0.1}) {
    double delta = (Random().nextDouble() * 2 - 1) * (max - min) * variation;
    return (current + delta).clamp(min, max);
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box("healthData");

    tempHistory = List<double>.from(box.get('Temperature Stats', defaultValue: []));
    humidityHistory = List<double>.from(box.get('Humidity Stats', defaultValue: []));
    pm25History = List<double>.from(box.get('PM2.5 Stats', defaultValue: []));
    pm10History = List<double>.from(box.get('PM10 Stats', defaultValue: []));
    uvHistory = List<double>.from(box.get('UV Index Stats', defaultValue: []));
    noiseHistory = List<double>.from(box.get('Noise Level Stats', defaultValue: []));

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        temperature = _smoothChange(temperature, 15, 40, variation: 0.08);
        humidity = _smoothChange(humidity, 20, 90, variation: 0.1);
        pm25 = _smoothChange(pm25, 5, 150, variation: 0.15);
        pm10 = _smoothChange(pm10, 10, 250, variation: 0.15);
        uvIndex = _smoothChange(uvIndex, 0, 11, variation: 0.25);
        noise = _smoothChange(noise, 30, 100, variation: 0.12);
      });

      void store(String key, List<double> history, double value) {
        history.add(value);
        if (history.length > 50) history.removeAt(0);
        box.put(key, history);
      }

      store('Temperature Stats', tempHistory, temperature);
      store('Humidity Stats', humidityHistory, humidity);
      store('PM2.5 Stats', pm25History, pm25);
      store('PM10 Stats', pm10History, pm10);
      store('UV Index Stats', uvHistory, uvIndex);
      store('Noise Level Stats', noiseHistory, noise);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _openStats(String title, String unit, Color color) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StatsPage(
          title: title,
          unit: unit,
          graphColor: color,
        ),
      ),
    );
  }

  Widget buildTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.grey.shade800),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                )),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // appBar: AppBar(
      //   backgroundColor: const Color(0xFF262744),
      //   elevation: 0,
      //   title: const Text("UrHealth", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF262744),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => const ChatBotPage(),
            ),
          );
        },
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,

      body: CustomScrollView(
        slivers: [

          // HERO SECTION
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF262744),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TOP TITLE (Instead of AppBar)
                  Center(
                    child: Text(
                      "UrHealth",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),


                  const SizedBox(height: 50),

                  const Text(
                    "Monitor Your Environment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Live air & health stats update automatically.",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Start Now"),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),


          // LIVE STATS TITLE
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Live Stats",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // GRID VIEW FIXED (NO GAPS)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.05,
              children: [
                buildTile(
                  icon: Icons.thermostat,
                  label: "Temperature",
                  value: "${temperature.toStringAsFixed(1)} °C",
                  onTap: () => _openStats("Temperature Stats", "°C", Colors.deepOrangeAccent),
                ),
                buildTile(
                  icon: Icons.water_drop,
                  label: "Humidity",
                  value: "${humidity.toStringAsFixed(1)} %",
                  onTap: () => _openStats("Humidity Stats", "%", Colors.lightBlueAccent),
                ),
                buildTile(
                  icon: Icons.cloud,
                  label: "PM 2.5",
                  value: "${pm25.toStringAsFixed(1)} µg/m³",
                  onTap: () => _openStats("PM2.5 Stats", "µg/m³", Colors.amber),
                ),
                buildTile(
                  icon: Icons.cloud_queue,
                  label: "PM 10",
                  value: "${pm10.toStringAsFixed(1)} µg/m³",
                  onTap: () => _openStats("PM10 Stats", "µg/m³", Colors.orange),
                ),
                buildTile(
                  icon: Icons.wb_sunny,
                  label: "UV Index",
                  value: uvIndex.toStringAsFixed(1),
                  onTap: () => _openStats("UV Index Stats", "", Colors.yellow.shade700),
                ),
                buildTile(
                  icon: Icons.volume_up,
                  label: "Noise Level",
                  value: "${noise.toStringAsFixed(1)} dB",
                  onTap: () => _openStats("Noise Level Stats", "dB", Colors.purpleAccent),
                ),
              ],
            ),
          ),

          // NO BOTTOM GAP
          const SliverToBoxAdapter(child: SizedBox(height: 90)),
        ],
      ),
    );
  }
}
