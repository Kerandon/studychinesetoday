import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../components/forms/custom_form_chips.dart';
import 'flash_cards_page.dart';
import 'flashcard_provider.dart';

class FlashcardsSettings extends ConsumerStatefulWidget {
  const FlashcardsSettings({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FlashcardsSettingsState();
}

class FlashcardsSettingsState extends ConsumerState<FlashcardsSettings> {
  final _formKey = GlobalKey<FormBuilderState>();

  int _totalCards = 0;

  @override
  Widget build(BuildContext context) {
    //  Set<Topic> topics = ref.read(topicProvider).topics;
    final flashcardManager = ref.watch(flashcardProvider);
    final flashcardNotifier = ref.watch(flashcardProvider.notifier);

    //print('total cards is ${flashcardManager.totalCards}');
    _totalCards = flashcardManager.totalCards;

    List<FormBuilderChipOption> chips = [];

    int preferredNumberCards = flashcardManager.preferredNumberOfCards;

    if (preferredNumberCards > _totalCards) {
      preferredNumberCards = _totalCards;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        flashcardNotifier.setPreferredNumberOfCards(
            number: preferredNumberCards);
      });
    }

    if (_totalCards > 0 && _totalCards <= 5) {
      chips = [
        FormBuilderChipOption(value: _totalCards),
      ];
    } else if (_totalCards > 5 && _totalCards <= 10) {
      chips = [
        const FormBuilderChipOption(value: 5),
        FormBuilderChipOption(value: _totalCards),
      ];
    } else if (_totalCards > 10 && _totalCards <= 20) {
      chips = [
        const FormBuilderChipOption(value: 5),
        const FormBuilderChipOption(value: 10),
        FormBuilderChipOption(value: _totalCards),
      ];
    } else if (_totalCards > 20 && _totalCards < 50) {
      chips = [
        const FormBuilderChipOption(value: 5),
        const FormBuilderChipOption(value: 10),
        const FormBuilderChipOption(value: 20),
        FormBuilderChipOption(value: _totalCards),
      ];
    } else if (_totalCards > 50) {
      chips = [
        FormBuilderChipOption(value: _totalCards),
      ];
    }

    //print('preferred number ${preferredNumberCards}');

    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_totalCards == 0)
              ...[]
            else ...[
              CustomFormChips(
                title: 'Total Cards Per Session',
                name: 'number',
                initialValue: preferredNumberCards,
                chips: chips,
              ),
              const CustomFormChips(
                title: 'Display Options',
                name: 'display',
                chips: [
                  FormBuilderChipOption(value: 'English First'),
                  FormBuilderChipOption(value: 'Chinese First'),
                  FormBuilderChipOption(value: 'Chinese First - Hide Pinyin'),
                  FormBuilderChipOption(value: 'Chinese Audio Only'),
                ],
                initialValue: 'English First',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 22, 8, 16),
                child: Text(
                  'Change Topic',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              // FormBuilderDropdown(
              //  // initialValue: topics.first.english,
              //   name: 'topic',
              //   // items: topics
              //   //     .map(
              //   //       (e) => DropdownMenuItem(
              //   //         value: e.english,
              //   //         child: SizedBox(
              //   //           width: size.width * 0.20,
              //   //           height: size.height * 0.06,
              //   //           child: Row(
              //   //             children: [
              //   //               Expanded(
              //   //                 child: DisplayImage(
              //   //                     imageFuture: getThumbnailURL(topic: e),
              //   //                     returnedURL: (url) {}),
              //   //               ),
              //   //               Expanded(
              //   //                   child: Text(
              //   //                 e.english,
              //   //                 style: Theme.of(context).textTheme.displaySmall,
              //   //               ))
              //   //             ],
              //   //           ),
              //   //         ),
              //   //       ),
              //   //     )
              //   //     .toList(),
              // ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  final isValidated = _formKey.currentState?.saveAndValidate();
                  if (isValidated == true) {
                    final int number =
                        _formKey.currentState!.fields['number']?.value;

                    ref
                        .read(flashcardProvider.notifier)
                        .setPreferredNumberOfCards(number: number);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FlashcardsPage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.displaySmall),
                child: const Text('Update'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
