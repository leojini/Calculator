
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:calculator/ui/widget/calc_button.dart';
import 'package:calculator/ui/widget/display_row.dart';

import 'package:calculator/data/calc_data.dart';
import 'package:calculator/data/calc_factory.dart';
import 'package:calculator/data/stream_data.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:calculator/admob/ad_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}): super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AdHelper? _adHelper;
  CalcFactory? _factory;
  StreamController _streamController = StreamController<StreamData>();

  final DisplayRow _displayRowFormula = DisplayRow(
    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
    const EdgeInsets.fromLTRB(20, 20, 20, 0),
  );
  final DisplayRow _displayRowResult = DisplayRow(
    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.pink),
    const EdgeInsets.fromLTRB(20, 0, 20, 0),
  );

  int _clickCount = 0;

  // init google mobile ads
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  void dispose() {
    _adHelper?.disposeAd();
    super.dispose();
  }

  @override
  void initState() {
    _adHelper = AdHelper(streamController: _streamController);
    _adHelper?.initBannerAd();

    _factory = CalcFactory(streamController: _streamController);

    bind();

    super.initState();
  }

  void bind() {
    _streamController.stream.listen((data) {
      StreamData streamData = data as StreamData;
      print('type : ${streamData.type}');
      switch (streamData.type) {
        case StreamType.setStateBannerAd:
          setState(() {
            _adHelper?.resetBannerAd((streamData as StreamAdData).adObject as BannerAd);
          });
          break;

        case StreamType.setStateInterstitalAd:
          setState(() {
            _adHelper?.resetInterstitialAd((streamData as StreamAdData).adObject as InterstitialAd);
          });
          break;

        case StreamType.button:
          _actionButton(streamData as StreamButtonData);
          break;

        case StreamType.calc:
          _calcResult(streamData as StreamCalcData);
          break;
      }
    });
  }

  void _actionButton(StreamButtonData data) {
    CalcType type = data.calcType;
    _clickCount++;
    if (_adHelper != null) {
      if (_clickCount == 1) {
        _adHelper?.initInterstitialAd();
      } else if (_clickCount == 5) {
        // interstitial ad
        if (_adHelper?.interstitialAd != null) {
          _adHelper?.interstitialAd?.show();
        }
        _clickCount = 0;
      }
    }

    _factory?.process(type);
  }

  void _calcResult(StreamCalcData data) {
    CalcType type = data.calcType;
    if (data.complete) {
      _displayRowFormula.remove();
      _displayRowResult.remove();
    } else {
      _displayRowFormula.addText(type.title);
      if (data.result) {
        _displayRowResult.remove();
        _displayRowResult.addText(_factory?.getResult() ?? '');
        _displayRowResult.nextRemove = (type == CalcType.equal);
      } else if (type.isOperatorMiddle) {

      } else {
        _displayRowResult.remove();
        _displayRowResult.addText(data.value);
      }
    }
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

    if (_adHelper?.bannerAd != null) {
      rows.add(Container(
        height: _adHelper?.bannerAd!.size.height.toDouble(),
      ));
    }

    return Stack(
      children: [
        Center(
          child: Column(
            children: rows,
          ),
        ),
        if (_adHelper != null && _adHelper?.bannerAd != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: _adHelper?.bannerAd!.size.width.toDouble(),
              height: _adHelper?.bannerAd!.size.height.toDouble(),
              child: _adHelper?.getBannerAdWidget(),
            ),
          ),
      ],
    );
  }

  Widget getButtonsRow(List<CalcType> btnDatas) {
    List<Widget> buttons = btnDatas.map((e) => CalcButton(type: e, streamController: _streamController).createButton()).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}