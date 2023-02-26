import 'package:flutter/material.dart';
import 'dart:convert';

// ignore: must_be_immutable
class CookieWidget extends StatefulWidget {
  factory CookieWidget.fromJson(Map<String, dynamic> json) {
    return CookieWidget(
      color: Color(json['color'] as int),
      title: json['title'],
      isVisible: json['isVisible'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'color': color.value,
      'title': title,
      'isVisible': isVisible,
    };
  }

  factory CookieWidget.fromMap(Map<String, dynamic> map) {
    return CookieWidget(
      title: map['title'] as String,
      isVisible: map['isVisible'] as bool,
      color: Color(map['color'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  // Componente (Widget) que representa um Biscoito
  final Color color;
  final String title;
  bool isVisible = true;
  CookieWidget(
      {Key? key,
      this.color = Colors.brown,
      required this.title,
      this.isVisible = true})
      : super(key: key);

  void setVisible() {
    isVisible = !isVisible;
  }

  @override
  State<CookieWidget> createState() => _CookieWidgetState();
}

class _CookieWidgetState extends State<CookieWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.isVisible
        ? Column(
            children: [
              Text(widget.title),
              Icon(
                Icons.cookie,
                color: widget.color,
                size: 40,
              ),
            ],
          )
        : Container();
  }
}
