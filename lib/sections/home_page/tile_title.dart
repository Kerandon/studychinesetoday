import 'package:flutter/material.dart';

class TileTitle extends StatelessWidget {
  const TileTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.05,
      width: double.infinity,
      child: Align(
        alignment: const Alignment(-0.90, 0.50),
        child: Text(
          title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
    );
  }
}
