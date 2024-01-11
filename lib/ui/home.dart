// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:calculator/data/calc_data.dart';
import 'package:calculator/data/calc_factory.dart';
import 'package:calculator/ui/widget/calc_button.dart';
import 'package:calculator/ui/widget/display_row.dart';
import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:calculator/admob/ad_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  // init google mobile ads
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }
}

class _HomeScreenState extends State<HomeScreen> {
// class Home extends StatelessWidget {
  final CalcFactory _factory = CalcFactory();
  final DisplayRow _displayRowFormula = DisplayRow(
    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
    const EdgeInsets.fromLTRB(20, 20, 20, 0),
  );
  final DisplayRow _displayRowResult = DisplayRow(
    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.pink),
    const EdgeInsets.fromLTRB(20, 0, 20, 0),
  );
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  int _clickCount = 0;

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initBannerAd();
  }

  void initBannerAd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
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

            setState(() {
              _interstitialAd = ad;
            });
          },
          onAdFailedToLoad: (err) {
            print('Failed to load an interstital ad: ${err.message}');
          }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    List<List<CalcType>> buttonDatas = CalcData.getOrderButtons();

    List<Widget> rows = [];
    rows.add(_displayRowFormula.createRow());
    rows.add(_displayRowResult.createRow());

    List<Widget> btnRows = buttonDatas.map((e) => getButtonsRow(e)).toList();
    Widget bottmButtons = Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: btnRows,
        ),
      )
    );
    rows.add(bottmButtons);

    if (_bannerAd != null) {
      rows.add(Container(
        height: _bannerAd!.size.height.toDouble(),
      ));
    }

    return Stack(
      children: [
        Center(
          child: Column(
          children: rows,
        ),
        ),
        if (_bannerAd != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          ),
      ],
    );
  }

  Widget getButtonsRow(List<CalcType> btnDatas) {
    PressedButtonCb callback = (CalcType type) {

      _clickCount++;
      if (_clickCount == 1) {
        initInterstitialAd();
      } else if (_clickCount == 5) {
        // interstitial ad
        if (_interstitialAd != null) {
          _interstitialAd?.show();
        }
        _clickCount = 0;
      }

      _factory.process(type, ({
        bool complete = false,
        bool result = false,
        String value= '',
      }) {
        if (complete) {
          _displayRowFormula.remove();
          _displayRowResult.remove();
        } else {
          _displayRowFormula.addText(type.title);
          if (result) {
            _displayRowResult.remove();
            _displayRowResult.addText(_factory.getResult());
            _displayRowResult.nextRemove = (type == CalcType.equal);
          } else if (type.isOperatorMiddle) {

          } else {
            _displayRowResult.remove();
            _displayRowResult.addText(value);
          }
        }
      });
    };

    List<Widget> buttons = btnDatas.map((e) => CalcButton(e).createButton(callback)).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}