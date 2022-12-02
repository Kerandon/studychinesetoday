import 'package:flutter/material.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/constants_other.dart';
import 'flash_cards_page.dart';

class FlashcardsButton extends StatelessWidget {
  const FlashcardsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: Container(
        width: size.width * 0.80,
        height: size.height * 0.30,
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FlashcardsPage(),
                ),
              );
            },
            child: Text(
              'Flashcards',
              style: Theme.of(context).textTheme.displayMedium,
            )),
      ),
    );
  }
}
