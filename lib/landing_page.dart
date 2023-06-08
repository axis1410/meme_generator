import 'package:flutter/material.dart';

import 'about.dart';
import 'creator_page.dart';
import 'home.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final int _currentIndex = 1;

  final tabs = [
    const HomePage(),
    const CreatorPage(),
    const AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      // bottomNavigationBar: Container(
      //   color: Colors.black,
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      //     child: GNav(
      //       backgroundColor: Colors.black,
      //       tabBackgroundColor: Colors.grey.shade800,
      //       padding: const EdgeInsets.all(16),
      //       color: Colors.white,
      //       activeColor: Colors.white,
      //       selectedIndex: _currentIndex,
      //       gap: 8,
      //       haptic: true,
      //       curve: Curves.easeInOut,
      //       onTabChange: (index) {
      //         setState(() {
      //           _currentIndex = index;
      //         });
      //       },
      //       tabs: const [
      //         GButton(icon: Icons.home, text: 'Home'),
      //         GButton(icon: Icons.whatshot, text: 'Create'),
      //         GButton(icon: Icons.info, text: 'About'),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
