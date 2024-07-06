// ignore_for_file: must_be_immutable

import 'package:dice_pt2/pages/view/settings_page.dart';
import 'package:dice_pt2/pages/view/starting_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenNavigation extends StatefulWidget {
  final SharedPreferences prefs;
  ScreenNavigation({super.key, required this.prefs});

  @override
  State<ScreenNavigation> createState() => _ScreenNavigationState();
}

class _ScreenNavigationState extends State<ScreenNavigation> {
  int _selectedIndex = 0;
  late List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens = [
      StartingPage(
        prefs: widget.prefs,
      ),
      SettingsPage(
        prefs: widget.prefs,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: gNavBar(),
    );
  }

  Widget gNavBar() {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        child: GNav(
          backgroundColor: Colors.black,
          color: const Color.fromARGB(255, 255, 255, 255),
          activeColor: const Color.fromARGB(255, 255, 255, 255),
          tabBackgroundColor: Colors.grey.shade800,
          padding: const EdgeInsets.all(16),
          tabs: const [
            //Home button
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            //Settings button
            GButton(
              icon: Icons.settings,
              text: 'Settings',
            ),
          ],
          onTabChange: (i) {
            setState(() {
              _selectedIndex = i;
            });
          },
        ),
      ),
    );
  }
}
