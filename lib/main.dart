// import 'package:dice_pt2/ads/ad_state.dart';
import 'package:dice_pt2/pages/auth/home_page.dart';
import 'package:dice_pt2/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Initialize Google Mobile Ads SDK
  MobileAds.instance.initialize();

  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: ['YOUR_REAL_DEVICE_ID'], // Replace with your device ID
  );

  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  SharedPreferences prefs = await SharedPreferences.getInstance();

  //uncomment to clear shared preferences will eventually have a debug mode to do this
  await prefs.clear();

  bool onboard = prefs.getBool('onboard') ?? false;
  print("onboard: $onboard");
  //need to print the tutorial value

  runApp(App(
    prefs: prefs,
    onboard: onboard,
  ));
}

class App extends StatelessWidget {
  final SharedPreferences prefs;
  final bool onboard;
  const App({super.key, required this.prefs, required this.onboard});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: TSystemTheme.lightTheme,
        darkTheme: TSystemTheme.darkTheme,
        home: HomePage(prefs: prefs));
  }
}
