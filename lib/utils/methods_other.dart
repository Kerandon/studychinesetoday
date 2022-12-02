import 'package:flutter/material.dart';

Offset getWidgetsGlobalPosition({required GlobalKey positionKey}) {
  RenderBox renderBox =
  positionKey.currentContext?.findRenderObject() as RenderBox;
  return renderBox.localToGlobal(Offset.zero);
}
