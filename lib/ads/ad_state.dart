import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1887949446151398/8463026254";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1887949446151398/1489142530";
    }
    return null;
  }

  static final BannerAdListener bannerListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad loaded: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Ad failed to load: ${ad.adUnitId}, $error');
    },
    onAdOpened: (ad) => debugPrint('Ad opened: ${ad.adUnitId}.'),
    onAdClosed: (ad) => debugPrint('Ad closed: ${ad.adUnitId}.'),
  );
}
