import 'package:flutter/material.dart';
import 'package:studychinesetoday/configs/constants.dart';

class HomePageTile extends StatelessWidget {
  const HomePageTile({
    super.key,
    required this.title,
    required this.callback,
  });

  final String title;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kRadius))),
          onPressed: callback,
          child: Center(
              child: Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
          )),
        ),
      ),
    );
  }
}
