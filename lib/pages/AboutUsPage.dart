import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),

      // TOP BAR
      body: CustomScrollView(
        slivers: [

          // HEADER SECTION
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xFF262744),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    "About Us",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12),

                  Text(
                    "Learn more about who we are and what we do.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CONTENT SECTION
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // OUR MISSION
                  const Text(
                    "Our Mission",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF262744),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCard(
                    "We aim to make health and environmental tracking simple, accurate, and accessible. Our platform helps users monitor essential air quality and wellness parameters in real-time.",
                  ),

                  const SizedBox(height: 25),

                  // WHO WE ARE
                  const Text(
                    "Who We Are",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF262744),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCard(
                    "UrHealth is a passionate team focused on creating smart, intuitive health tracking tools. We combine technology with modern UI design to give users a seamless experience.",
                  ),

                  const SizedBox(height: 25),

                  // WHAT WE DO
                  const Text(
                    "What We Do",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF262744),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCard(
                    "✔ Real-time health monitoring\n"
                        "✔ Environment & air quality tracking\n"
                        "✔ Detailed statistics and insights\n"
                        "✔ Easy-to-use dashboards\n"
                        "✔ Beautiful UI optimized for everyday use",
                  ),

                  const SizedBox(height: 30),

                  // CONTACT
                  const Text(
                    "Contact Us",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF262744),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCard(
                    "📧 Email: support@urhealth.com\n"
                        "🌐 Website: www.urhealth.com\n"
                        "📍 Location: India",
                  ),

                  const SizedBox(height: 60), // spacing above bottom nav
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Card Builder Widget
  static Widget _buildCard(String text) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 15,
          height: 1.5,
        ),
      ),
    );
  }
}
