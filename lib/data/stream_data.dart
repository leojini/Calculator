import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:calculator/data/calc_data.dart';

enum StreamType {
  setStateBannerAd,
  setStateInterstitalAd,
  button,
  calc
}

class StreamData {
  final StreamType type;
  StreamData({required this.type});
}

class StreamAdData extends StreamData {
  final Ad adObject;
  StreamAdData({required super.type, required this.adObject});
}

class StreamButtonData extends StreamData {
  final CalcType calcType;
  StreamButtonData({required super.type, required this.calcType});
}

class StreamCalcData extends StreamData {
  final CalcType calcType;
  final bool complete;
  final bool result;
  final String value;
  StreamCalcData({
    required super.type,
    required this.calcType,
    required this.complete,
    required this.result,
    required this.value});
}