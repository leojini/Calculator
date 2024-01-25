
enum CalcType {
  zero(title: '0'),  // 0
  one(title: '1'),   // 1
  two(title: '2'),   // 2
  three(title: '3'), // 3
  four(title: '4'),  // 4
  five(title: '5'),  // 5
  six(title: '6'),   // 6
  seven(title: '7'), // 7
  eight(title: '8'), // 8
  nine(title: '9'),  // 9
  ac(title: 'AC'),   // AC
  plus(title: '+'),        // +
  minus(title: '-'),       // -
  multiply(title: 'x'),    // *
  divide(title: '/'),      // '/'
  equal(title: '='),       // =
  delete(title: '<-'),      // <-, back space
  empty(title: '');

  final String title;
  const CalcType({
    required this.title
  });

  bool get isNumber {
    try {
      int.parse(this.title);
    } on Exception {
      return false;
    }
    return true;
  }

  int get number {
    int n = -1;
    try {
      n = int.parse(this.title);
    } on Exception {

    }
    return n;
  }

  bool get isOperatorMiddle {
    if (this == CalcType.plus || this == CalcType.minus ||
       this == CalcType.multiply || this == CalcType.divide) {
      return true;
    }
    return false;
  }

  static double calcValue(CalcType type, int value1, int value2) {
    double result = 0.0;
    switch (type) {
      case CalcType.plus:
        result = (value1 + value2).toDouble();
        break;
      case CalcType.minus:
        result = (value1 - value2).toDouble();
        break;
      case CalcType.multiply:
        result = (value1 * value2).toDouble();
        break;
      case CalcType.divide:
        result = (value1 / value2).toDouble();
        break;
      default:
    }
    return result;
  }
}

class CalcData {
  // 버튼 각 행단위 config를 반환한다.
  static List<List<CalcType>> getOrderButtonsConfig() {
    return [
      [CalcType.ac, CalcType.empty, CalcType.empty, CalcType.plus],
      [CalcType.seven, CalcType.eight, CalcType.nine, CalcType.minus],
      [CalcType.four, CalcType.five, CalcType.six, CalcType.multiply],
      [CalcType.one, CalcType.two, CalcType.three, CalcType.divide],
      [CalcType.zero, CalcType.empty, CalcType.empty, CalcType.equal],
    ];
  }
}