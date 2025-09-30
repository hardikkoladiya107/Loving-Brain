import 'dart:convert';
/// behaviour : ""

BehaviourModel behaviourModelFromJson(String str) => BehaviourModel.fromJson(json.decode(str));
String behaviourModelToJson(BehaviourModel data) => json.encode(data.toJson());
class BehaviourModel {
  BehaviourModel({
      String? behaviour,}){
    _behaviour = behaviour;
}

  BehaviourModel.fromJson(dynamic json) {
    _behaviour = json['behaviour'];
  }
  String? _behaviour;
BehaviourModel copyWith({  String? behaviour,
}) => BehaviourModel(  behaviour: behaviour ?? _behaviour,
);
  String? get behaviour => _behaviour;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['behaviour'] = _behaviour;
    return map;
  }

}