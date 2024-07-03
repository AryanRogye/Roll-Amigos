// ignore_for_file: must_be_immutable

import 'package:dice_pt2/components/firebase/firebase_functions.dart';
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
  late List<Widget> _screens;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _screens = [
      const Center(child: CircularProgressIndicator()),
      const Center(child: CircularProgressIndicator())
    ]; // Initialize with loading indicators
    initializeScreen();
  }

  Future<void> initializeScreen() async {
    try {
      var user = await FirebaseFunctions.getFirstNameLastName();
      var firstName = user[0];
      var lastName = user[1];
      if (mounted) {
        setState(() {
          _screens = [
            StartingPage(
                prefs: widget.prefs, firstName: firstName, lastName: lastName),
            SettingsPage(
                prefs: widget.prefs, firstName: firstName, lastName: lastName),
          ];
          _isLoading = false;
        });
      }
    } catch (error) {
      // Handle errors here if necessary
      print('Error initializing screen: $error');
      // Show an error message if needed
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator if still loading
          : _screens[_selectedIndex],
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
