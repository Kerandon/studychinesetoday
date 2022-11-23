import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
        height: double.infinity,
        color: Colors.amber,
        child: Center(child: CircularProgressIndicator()));
  }
}