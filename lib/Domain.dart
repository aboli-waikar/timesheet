class Domain {
  /// Any domain model class should have an id property which
  /// represents the value of the PK column.
  dynamic _id;

  dynamic get id => _id;

  Map<String, dynamic> toMap() {}

  Map<String, dynamic> toUpdateMap() {}
}