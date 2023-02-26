// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:fabrica_de_biscoitos/models/order.dart';
import 'package:fabrica_de_biscoitos/models/oven.dart';

class Line {
  String name;
  bool canMakeSweet;
  Oven oven;
  List<CookieOrder> waitLine = [];
  bool isFree = true;

  Line({
    required this.name,
    required this.canMakeSweet,
    required this.oven,
    required this.waitLine,
  });

  void addToWaitLine(CookieOrder order) {
    waitLine.add(order);
  }

  void setOven() {}

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'canMakeSweet': canMakeSweet,
      'oven': oven.toMap(),
      'waitLine': waitLine.map((x) => x.toMap()).toList(),
      'isFree': isFree,
    };
  }

  factory Line.fromMap(Map<String, dynamic> map) {
    return Line(
      name: map['name'] as String,
      canMakeSweet: map['canMakeSweet'] as bool,
      oven: Oven.fromMap(map['oven'] as Map<String, dynamic>),
      waitLine: List<CookieOrder>.from(
        (map['waitLine'] as List<int>).map<CookieOrder>(
          (x) => CookieOrder.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Line.fromJson(String source) =>
      Line.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LineA extends Line {
  LineA({
    required super.name,
    super.canMakeSweet = true,
    required super.oven,
    required super.waitLine,
  });
}

class LineB extends Line {
  late Oven oven1;
  late Oven oven2;
  LineB({
    required super.name,
    super.canMakeSweet = true,
    required super.oven,
    required super.waitLine,
    required this.oven1,
    required this.oven2,
  });
  @override
  void setOven() {
    // se for a linha B escolhe o forno que estiver disponivel primeiro
    if (oven1.isFree) {
      oven = oven1;
    } else if (oven2.isFree) {
      oven = oven2;
    }
  }
}

class LineC extends Line {
  LineC({
    required super.name,
    super.canMakeSweet = false,
    required super.oven,
    required super.waitLine,
  });
}
