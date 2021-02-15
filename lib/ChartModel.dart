class ChartModel {
  final DateTime Date;
  final double Hrs;

  ChartModel(this.Date, this.Hrs);

  @override
  String toString() {
    return "ChartModel($Date, $Hrs)";
  }
}