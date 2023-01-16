import 'line.dart';

class Oven {
  int id;
  bool isFree;
  String line;

  Oven({required this.id, required this.isFree, required this.line});

  void assignLine(Line line) {
    this.line = line.name;
    isFree = false;
  }

  void setIsFree() {
    isFree = !isFree;
  }
}
