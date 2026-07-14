class BehaviourCategoryModel {
  BehaviourCategoryModel({String? behaviour}) {
    _behaviour = behaviour;
  }

  BehaviourCategoryModel.fromJson(dynamic json) {
    _behaviour = json['behaviour'];
  }
  String? _behaviour;
  BehaviourCategoryModel copyWith({String? behaviour}) =>
      BehaviourCategoryModel(behaviour: behaviour ?? _behaviour);
  String? get behaviour => _behaviour;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['behaviour'] = _behaviour;
    return map;
  }
}
