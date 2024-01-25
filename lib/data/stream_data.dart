import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:calculator/data/calc_data.dart';


// StreamController에서 사용할 type 정의
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

// 스트림 광고 데이터
class StreamAdData extends StreamData {
  final Ad adObject;
  StreamAdData({required super.type, required this.adObject});
}

// 스트림 버튼 데이터
class StreamButtonData extends StreamData {
  final CalcType calcType;
  StreamButtonData({required super.type, required this.calcType});
}

// 스트림 계산 데이터
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