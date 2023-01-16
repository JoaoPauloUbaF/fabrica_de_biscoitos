import 'package:fabrica_de_biscoitos/models/order.dart';
import 'package:fabrica_de_biscoitos/models/oven.dart';

class Line {
  String name;
  bool canMakeSweet;
  Oven oven;
  List<Order> waitLine = [];
  bool isFree = true;

  Line({
    required this.name,
    required this.canMakeSweet,
    required this.oven,
    required this.waitLine,
  });

  void addToWaitLine(Order order) {
    waitLine.add(order);
  }

  void setOven() {}
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
