// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'line.dart';

class Oven {
  int id;
  bool isFree;

  Oven({required this.id, required this.isFree});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'isFree': isFree,
    };
  }

  factory Oven.fromMap(Map<String, dynamic> map) {
    return Oven(
      id: map['id'] as int,
      isFree: map['isFree'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Oven.fromJson(String source) =>
      Oven.fromMap(json.decode(source) as Map<String, dynamic>);
}
