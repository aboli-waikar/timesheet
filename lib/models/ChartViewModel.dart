class ChartViewModel {
  final DateTime date;
  final num hrs;
  final String projectName;

  // final num Min;

  ChartViewModel(this.date, this.hrs, this.projectName);

  num getMins() {
    var x = hrs.toInt();
    var mins = hrs - x;
    var y = x * 60 + mins * 100;
    return y;
  }

  String getHrsMin(num min) {
    return (min ~/ 60 + (min % 60) / 100).toStringAsFixed(2);
  }

  @override
  String toString() {
    return "ChartModel($date, $hrs, $projectName)";
  }
}
