import 'dart:math';

import 'package:flutter/material.dart';

Offset getWidgetGlobalPosition({required GlobalKey positionKey}) {
  RenderBox renderBox =
  positionKey.currentContext?.findRenderObject() as RenderBox;
  return renderBox.localToGlobal(Offset.zero);
}

Size getWidgetSize({required GlobalKey key}) {
  if (key.currentContext != null) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size;
  } else {
    return const Size(0, 0);
  }
}

int getRandomPositiveOrNegativeInt({required int max, int? min}) {
  int value = Random().nextInt(max);
  if(min != null && value < min){
    value == min;
  }
  bool isNegativeWidth = Random().nextBool();
  if(isNegativeWidth){
    value *= -1;
  }
  return value;
}