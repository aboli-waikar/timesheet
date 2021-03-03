class ChartModel {
  final DateTime date;
  final num hrs;

  // final num Min;

  ChartModel(this.date, this.hrs);

  num getMins() {
    var x = hrs.toInt();
    var mins = hrs - x;
    var y = x * 60 + mins*100;
    return y;
  }

  String getHrsMin(num min) {
    return (min~/60 + (min%60)/100).toStringAsFixed(2);
  }

  @override
  String toString() {
    return "ChartModel($date, $hrs)";
  }
}
