import 'package:flutter/material.dart';

class HealthCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String statValue;
  final VoidCallback? onTap; // 👈 new parameter

  const HealthCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.statValue,
    this.onTap, // 👈 optional callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 👈 makes the card clickable
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
        decoration: BoxDecoration(
          color: const Color(0xFF1B52D7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side (icon + title)
            Row(
              children: [
                Icon(icon, color: iconColor, size: 30),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            // Right side (stat value)
            Text(
              statValue,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
