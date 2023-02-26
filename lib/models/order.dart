// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fabrica_de_biscoitos/widgets/cookie_widget.dart';

import 'line.dart';

class CookieOrder {
  String id;
  double ingredient1;
  double ingredient2;
  double ingredient3;
  late Line line;
  late double totalTime;
  late CookieWidget cookieWidget = CookieWidget(title: '$id');
  late Offset positionOfTheRequest = const Offset(0, 0);
  bool isSweet;
  late double timeConstant = 0.0;
  late bool inMovement = false;
  late String userEmail;
  late bool isDone = true;

  CookieOrder({
    required this.ingredient1,
    required this.ingredient2,
    required this.ingredient3,
    required this.isSweet,
    required this.cookieWidget,
    required this.id,
    this.totalTime = 0.0,
    required this.timeConstant,
    required this.userEmail,
    required this.isDone,
  });

  Future<String> getUser() async {
    String? userEmail = await FirebaseAuth.instance.currentUser?.email;
    userEmail != null ? userEmail = userEmail : userEmail = '';
    return userEmail;
  }

  void assignLine(List<Line> lines) {
    // Vê qual fila das linhas está disponível e com menos pedidos do tipo
    Line nextWaitLine = _nextWaitLine(lines);
    if (!isDone) {
      nextWaitLine.addToWaitLine(this);
      if (nextWaitLine.name == "LineA") {
        line = nextWaitLine;
        positionOfTheRequest = const Offset(55, 25);
      } else if (nextWaitLine.name == "LineB") {
        line = nextWaitLine;
        positionOfTheRequest = const Offset(250, 25);
      } else if (nextWaitLine.name == "LineC") {
        line = nextWaitLine;
        positionOfTheRequest = const Offset(425, 25);
      }
    }
  }

  void assignLineToDoneOrders(List<Line> lines, String lineName) {
    // Vê qual fila das linhas está disponível e com menos pedidos do tipo
    if (lineName == "LineA") {
      line = lines[0];
    } else if (lineName == "LineB") {
      line = lines[1];
    } else if (lineName == "LineC") {
      line = lines[2];
    }
  }

  double calculateCookingTime(double T) {
    //calcula o tempo proporcional aos ingredientes e com o fator do tipo
    return isSweet
        ? 1.2 * (ingredient1 + ingredient2 + ingredient3) * T
        : 1.0 * (ingredient1 + ingredient2 + ingredient3) * T;
  }

  Future<void> moveToOven() async {
    if (!isDone && inMovement) {
      double totalCookingTime = calculateCookingTime(timeConstant);
      line.isFree = false;
      // Muda a posição pro quadrante Ingrediente 2
      await Future.delayed(Duration(seconds: 1), () {
        positionOfTheRequest = positionOfTheRequest.translate(0, 60);
      });
      // Muda a posição pro quadrante Ingrediente 3
      await Future.delayed(Duration(seconds: 2), () {
        positionOfTheRequest = positionOfTheRequest.translate(0, 60);
      });
      // Muda a posição pro Forno
      do {
        line.setOven();
        await Future.delayed(Duration(seconds: 1), () {
          if (line.oven.id == 1 && line.oven.isFree) {
            positionOfTheRequest = Offset(130, 270);
          } else if (line.oven.id == 2 && line.oven.isFree) {
            positionOfTheRequest = Offset(330, 270);
          }
        });
      } while (!line.oven.isFree); //espera o forno ficar disponível
      line.oven.isFree = false;
      // depois de passado o tempo de assar, passa para fora do Stack
      await Future.delayed(Duration(seconds: totalCookingTime.toInt()), () {
        positionOfTheRequest = positionOfTheRequest.translate(0, 300);
        totalTime += totalCookingTime;
        inMovement = false;
      });
      line.oven.isFree = true;
      line.isFree = true;
      isDone = true;
      cookieWidget.isVisible = false;
    }
  }

  Line _nextWaitLine(List<Line> lines) {
    // checa as linhas para ver qual tem menos pedidos de cada tipo, prioridade A->B->C
    int lineAWaitList = lines[0].waitLine.length;
    int lineBWaitList = lines[1].waitLine.length;
    int lineCWaitList = lines[2].waitLine.length;

    if (isSweet) {
      if (lineAWaitList <= lineBWaitList) {
        return lines[0];
      } else {
        return lines[1];
      }
    } else {
      if (lineAWaitList <= lineBWaitList && lineAWaitList <= lineCWaitList) {
        return lines[0];
      } else if (lineBWaitList <= lineCWaitList &&
          lineBWaitList <= lineAWaitList) {
        return lines[1];
      } else if (lineCWaitList <= lineBWaitList &&
          lineCWaitList <= lineAWaitList) {
        return lines[2];
      }
    }
    return lines[0];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ingredient1': ingredient1,
      'ingredient2': ingredient2,
      'ingredient3': ingredient3,
      'isSweet': isSweet,
      'cookieWidget': cookieWidget.toJson(),
      'userEmail': userEmail,
      'totalTime': totalTime,
      'timeConstant': timeConstant,
      'line': line.name,
      'isDone': isDone,
    };
  }

  factory CookieOrder.fromJson(Map<String, dynamic> json) {
    return CookieOrder(
      id: json['id'] as String,
      ingredient1: json['ingredient1'] as double,
      ingredient2: json['ingredient2'] as double,
      ingredient3: json['ingredient3'] as double,
      totalTime: json['totalTime'] as double,
      cookieWidget: json['cookieWidget'] is String
          ? CookieWidget.fromJson(jsonDecode(json['cookieWidget']))
          : CookieWidget.fromJson(json['cookieWidget']),
      isSweet: json['isSweet'] as bool,
      timeConstant: json['timeConstant'] as double,
      userEmail: json['userEmail'] as String,
      isDone: json['isDone'] as bool,
    );
  }

  factory CookieOrder.fromMap(Map<String, dynamic> map) {
    return CookieOrder(
      id: map['id'] as String,
      ingredient1: map['ingredient1'] as double,
      ingredient2: map['ingredient2'] as double,
      ingredient3: map['ingredient3'] as double,
      isSweet: map['isSweet'] as bool,
      timeConstant: 1,
      cookieWidget: CookieWidget(title: map['id'] as String),
      userEmail: map['userEmail'] as String,
      isDone: map['isDone'] as bool,
    );
  }

  Map<String, dynamic> toJson() => toMap();
}
