class RoutineCategoryModel {
  RoutineCategoryModel({String? routineType}) {
    _routineType = routineType;
  }

  RoutineCategoryModel.fromJson(dynamic json) {
    _routineType = json['routine_type'];
  }

  String? _routineType;

  RoutineCategoryModel copyWith({String? routineType}) =>
      RoutineCategoryModel(routineType: routineType ?? _routineType);

  String? get routineType => _routineType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['routine_type'] = _routineType;
    return map;
  }
}
