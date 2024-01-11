import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:calculator/data/stream_data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  final StreamController streamController;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  BannerAd? get bannerAd => _bannerAd;
  InterstitialAd? get interstitialAd => _interstitialAd;

  AdHelper({required this.streamController});

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  void disposeAd() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }

  AdWidget getBannerAdWidget() {
    return AdWidget(ad: _bannerAd!);
  }

  void initBannerAd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // setState(() {
          //   _bannerAd = ad as BannerAd;
          // });

          streamController.sink.add(StreamAdData(
              type: StreamType.setStateBannerAd,
              adObject: ad)
          );
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  void resetBannerAd(BannerAd ad) {
    _bannerAd = ad;
  }

  void initInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              ad.fullScreenContentCallback = FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad) {

                  }
              );

              streamController.sink.add(StreamAdData(
                  type: StreamType.setStateInterstitalAd,
                  adObject: ad)
              );
            },
            onAdFailedToLoad: (err) {
              print('Failed to load an interstital ad: ${err.message}');
            }
        )
    );
  }

  void resetInterstitialAd(InterstitialAd ad) {
    _interstitialAd = ad;
  }
}