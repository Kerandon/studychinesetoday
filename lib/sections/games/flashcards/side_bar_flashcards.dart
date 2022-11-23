import 'package:flutter/material.dart';
import 'flashcard_settings.dart';

class SideBarFlashcards extends StatefulWidget {
  const SideBarFlashcards({
    super.key,
  });

  @override
  State<SideBarFlashcards> createState() => _SideBarFlashcardsState();
}

class _SideBarFlashcardsState extends State<SideBarFlashcards> {
  bool _isExpanded = true;

  _setExpand({required bool expand}) {
    _isExpanded = expand;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _isExpanded ? size.width * 0.20 : size.width * 0.05,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black12,
      ),
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              _setExpand(expand: !_isExpanded);
            },
            icon: _isExpanded
                ? const Icon(Icons.minimize)
                : const RotatedBox(
                    quarterTurns: 1,
                    child: Icon(Icons.expand),
                  ),
          ),
          const ListTile(
            title: Text('Settings'),
          ),
          const FlashcardsSettings()
        ],
      ),
    );
  }
}
