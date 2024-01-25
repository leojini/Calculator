
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:calculator/ui/widget/calc_button.dart';
import 'package:calculator/ui/widget/display_row.dart';

import 'package:calculator/data/calc_data.dart';
import 'package:calculator/data/calc_factory.dart';
import 'package:calculator/data/stream_data.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:calculator/admob/ad_helper.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}): super(key: key);

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

  bool _prevShowInterstital = true;
  int _clickCount = 0;
  int _lastClickCount = 30;

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

    _generateLastClickCount();

    bind();

    super.initState();
  }

  void bind() {
    // streamController를 이용해서 streamData type에 따른 비동기 처리를 한다.
    _streamController.stream.listen((data) {
      StreamData streamData = data as StreamData;
      debugPrint('type : ${streamData.type}');
      switch (streamData.type) {
        case StreamType.setStateBannerAd: // 배너 광고
          setState(() {
            _adHelper?.resetBannerAd((streamData as StreamAdData).adObject as BannerAd);
          });
          break;

        case StreamType.setStateInterstitalAd: // 전면 광고
          setState(() {
            _adHelper?.resetInterstitialAd((streamData as StreamAdData).adObject as InterstitialAd);
          });
          break;

        case StreamType.button: // 버튼
          _actionButton(streamData as StreamButtonData);
          break;

        case StreamType.calc: // 계산
          _calcResult(streamData as StreamCalcData);
          break;
      }
    });
  }

  void _generateLastClickCount() {
    _lastClickCount = Random().nextInt(10) + 20; // 20에서 30사이
  }

  void _actionButton(StreamButtonData data) {
    CalcType type = data.calcType;

    _clickCount++;
    // debugPrint('_clickCount: ${_clickCount}, _lastClickCount: ${_lastClickCount}');

    if (_prevShowInterstital) {
      // 전면 광고 초기화
      _adHelper?.initInterstitialAd();
      _prevShowInterstital = false;
    }

    // AC 버튼 눌렀을 때 clickCount가 lastClickCount보다 크거나 같은 경우
    if (type == CalcType.ac && _clickCount >= _lastClickCount) {
      // 전면 광고를 보여준다.
      if (_adHelper?.interstitialAd != null) {
        _adHelper?.interstitialAd?.show();
      }
      _prevShowInterstital = true;
      _clickCount = 0;
      _generateLastClickCount();
    }

    _factory?.process(type);
  }

  void _calcResult(StreamCalcData data) {
    CalcType type = data.calcType;
    if (data.complete) { // 완료된 경우
      _displayRowFormula.remove(); // 계산 과정 삭제
      _displayRowResult.remove(); // 계산 결과 삭제
    } else {
      _displayRowFormula.addText(type.title);
      if (data.result) { // 결과인 경우
        _displayRowResult.remove(); // 계산 결과 삭제
        _displayRowResult.addText(_factory?.getResult() ?? ''); // 결과 값을 추가
        _displayRowResult.nextRemove = (type == CalcType.equal); // 등호(=)인 경우 다음번 삭제 플래그 true로 설정
      } else if (type.isOperatorMiddle) { // 연산 기호(+, -, x, /)일 경우

      } else {
        _displayRowResult.remove(); // 계산 결과 삭제
        _displayRowResult.addText(data.value); // 값 추가
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<List<CalcType>> buttonsConfig = CalcData.getOrderButtonsConfig();

    List<Widget> rows = [];

    // 계산 과정 row 추가
    rows.add(_displayRowFormula.createRow());

    // 계산 결과 row 추가
    rows.add(_displayRowResult.createRow());

    // 버튼 config에 해당하는 button widget 리스트를 가져온다.
    List<Widget> btnRows = buttonsConfig.map((e) => getButtonsRow(e)).toList();
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

    // 광고 배너 인스턴스가 있을 경우 row에 추가
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

  // btnDatas의 데이터에 해당하는 계산기 버튼 생성 후 해당 Row widget을 반환한다.
  Widget getButtonsRow(List<CalcType> btnDatas) {
    List<Widget> buttons = btnDatas.map((e) => CalcButton(type: e, streamController: _streamController).createButton()).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}