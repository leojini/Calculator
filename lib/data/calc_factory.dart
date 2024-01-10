import 'package:flutter/foundation.dart';
import 'package:calculator/data/calc_data.dart';

typedef ProcessResultCB = void Function({required bool complete,
                                          required bool result,
                                          required String value});

class CalcFactory {
  CalcType _sign = CalcType.empty; // 입력된 기호 CalcType
  String _result = ''; // 결과
  String _prev = '', _next = '';

  void process(CalcType type, ProcessResultCB callback) {
    if (_prev.length == 0) {
      // 첫 번째 입력값 숫자인 경우
      if (type.isNumber) {
        _prev = getDoubleExceptDotZero(type.title);
        callback(complete: false, result: false, value: _prev);
      }
    } else {
      // 두 번째 이상의 입력값 숫자인 경우
      if (type.isNumber) {
        if (_sign != CalcType.empty) {
          _next = getDoubleExceptDotZero('$_next${type.title}');
          callback(complete: false, result: false, value: _next);
        } else {
          _prev = getDoubleExceptDotZero('$_prev${type.title}');
          callback(complete: false, result: false, value: _prev);
        }
      } else if (type.isOperatorMiddle || type == CalcType.equal) {
        if (type != CalcType.equal) {
          _sign = type;
        }

        if (_prev.length > 0 && _next.length > 0) {
          build();
          callback(complete: false, result: true, value: _result);
        } else {
          callback(complete: false, result: true, value: '');
        }
      } else if (type == CalcType.ac) {
        reset();
        callback(complete: true, result: false, value: ''); // 초기화
      }
    }
  }

  String getResult() {
    return getDoubleExceptDotZero('$_result');
  }

  // 소수점 이하가 0인 경우 소수점을 제외한 정수 형태의 문자열을 반환한다.
  // 그 이외의 경우 기존 문자열을 반환다.
  static String getDoubleExceptDotZero(String res) {
    int index = res.indexOf('.');
    if (index < 0) {
      return res;
    } else {
      String str = res.substring(index + 1);
      int value = 0;
      try {
        value = int.parse(str);
      } on Exception {

      }

      if (value > 0) {
        return res;
      } else {
        return res.substring(0, index);
      }
    }
  }

  void reset() {
    _prev = '';
    _next = '';
    _sign = CalcType.empty;
    debugPrint('reset');
  }

  // 입력된 버퍼에 CalcType을 분석하여 결과를 저장한다.
  void build() {
    int prev = 0;
    try {
      prev = int.parse(_prev);
    } on Exception {
    }

    int next = 0;
    try {
      next = int.parse(_next);
    } on Exception {
    }

    double result = CalcType.calcValue(_sign, prev, next);
    _result = getDoubleExceptDotZero('$result');
    _prev = _result;
    _next = '';
  }
}