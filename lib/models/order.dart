import 'package:fabrica_de_biscoitos/models/oven.dart';
import 'package:fabrica_de_biscoitos/widgets/cookie_widget.dart';
import 'package:flutter/material.dart';

import 'cookie.dart';

import "dart:math";
import 'line.dart';

class Order {
  int id;
  double ingredient1;
  double ingredient2;
  double ingredient3;
  late Line line;
  late int cookedIn;
  late double totalTime;
  late CookieWidget cookieWidget;
  late Offset positionOfTheRequest = const Offset(55, 25);
  bool isSweet;

  Order({
    required this.ingredient1,
    required this.ingredient2,
    required this.ingredient3,
    required this.isSweet,
    required this.cookieWidget,
    required this.id,
  });

  void assignLine(List<Line> lines) {
    // code to assign order to line
    bool gotAssigned = false;
    for (var i = 0; i < lines.length; i++) {
      if (isSweet && lines[i].canMakeSweet && lines[i].isFree) {
        line = lines[i];
        if (line.name == "LineA") {
          positionOfTheRequest = Offset(55, 25);
          gotAssigned = true;
          line.setIsFree();
        } else if (line.name == "LineB") {
          positionOfTheRequest = Offset(250, 25);
          gotAssigned = true;
          line.setIsFree();
        }
        break;
      } else if (!isSweet && lines[i].isFree) {
        line = lines[i];
        if (line.name == "LineA") {
          positionOfTheRequest = Offset(55, 25);
          gotAssigned = true;
          line.setIsFree();
        } else if (line.name == "LineB") {
          positionOfTheRequest = Offset(250, 25);
          gotAssigned = true;
          line.setIsFree();
        } else if (line.name == "LineC") {
          positionOfTheRequest = Offset(425, 25);
          gotAssigned = true;
          line.setIsFree();
        }
        break;
      }
    }
    if (!gotAssigned) {
      cookieWidget.setVisible();
      int nextWaitLine = _nextWaitLine(lines);
      lines[nextWaitLine].addToWaitLine(this);
    }
    if (gotAssigned) {
      moveToOven();
    }
  }

  double calculateCookingTime(double T) {
    return isSweet
        ? 1.2 * (ingredient1 + ingredient2 + ingredient3) * T
        : 1.0 * (ingredient1 + ingredient2 + ingredient3) * T;
  }

  Future<void> moveToOven() async {
    double totalCookingTime = calculateCookingTime(1);
    // change position of cookie by adding 50 to y coordinate in first 2 seconds
    await Future.delayed(Duration(seconds: 1), () {
      positionOfTheRequest = positionOfTheRequest.translate(0, 60);
    });
    await Future.delayed(Duration(seconds: 2), () {
      positionOfTheRequest = positionOfTheRequest.translate(0, 60);
    });
    // change position to oven coordinates in next second

    do {
      line.setOven();
      await Future.delayed(Duration(seconds: 1), () {
        if (line.oven.id == 1 && line.oven.isFree) {
          positionOfTheRequest = Offset(130, 270);
        } else if (line.oven.id == 2 && line.oven.isFree) {
          positionOfTheRequest = Offset(330, 270);
        }
      });
    } while (!line.oven.isFree);
    line.setIsFree();
    line.oven.isFree = false;
    // after totalCookingTime seconds, move cookie to final position
    await Future.delayed(Duration(seconds: totalCookingTime.toInt()), () {
      print(totalCookingTime.toInt());
      positionOfTheRequest = positionOfTheRequest.translate(0, 300);
      line.oven.isFree = true;
    });
  }

  int _nextWaitLine(List<Line> lines) {
    int lineAWaitList = lines[0].waitLine.length;
    int lineBWaitList = lines[1].waitLine.length;
    int lineCWaitList = lines[2].waitLine.length;

    if (isSweet) {
      if (lineAWaitList <= lineBWaitList) {
        return 0;
      } else {
        return 1;
      }
    } else {
      if (lineAWaitList <= lineBWaitList && lineAWaitList <= lineCWaitList) {
        return 0;
      } else if (lineBWaitList <= lineCWaitList &&
          lineBWaitList <= lineAWaitList) {
        return 1;
      } else if (lineCWaitList <= lineBWaitList &&
          lineCWaitList <= lineAWaitList) {
        return 2;
      }
    }
    return 0;
  }
}
