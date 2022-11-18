import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/state_management/flashcard_provider.dart';
import '../../models/topic.dart';
import '../../pages/flash_cards_page.dart';
import '../../state_management/topic_providers.dart';
import '../../utils/methods.dart';
import '../app/display_image.dart';
import '../forms/custom_form_chips.dart';

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Set<Topic> topics = ref.read(topicProvider).topics;

    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomFormChips(
              title: 'Number of Cards',
              name: 'number',
              initalValue: 10,
              chips: [
                FormBuilderChipOption(value: 5),
                FormBuilderChipOption(value: 10),
                FormBuilderChipOption(value: 20),
                FormBuilderChipOption(value: 50),
                FormBuilderChipOption(value: 100),
                FormBuilderChipOption(value: 'All'),
              ],
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
              initalValue: 'English First',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 22, 8, 16),
              child: Text(
                'Change Topic',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            FormBuilderDropdown(
              initialValue: topics.first.english,
              name: 'topic',
              items: topics
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.english,
                      child: SizedBox(
                        width: size.width * 0.20,
                        height: size.height * 0.06,
                        child: Row(
                          children: [
                            Expanded(
                              child: DisplayImage(
                                  imageFuture: getThumbnailURL(topic: e),
                                  returnedURL: (url) {

                                  }),
                            ),
                            Expanded(
                                child: Text(
                              e.english,
                              style: Theme.of(context).textTheme.displaySmall,
                            ))
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                final isValidated = _formKey.currentState?.saveAndValidate();
                if (isValidated == true) {
                  final int number =
                      _formKey.currentState!.fields['number']?.value;
                  final Topic topic =
                      _formKey.currentState!.fields['topic']?.value;

                  ref
                      .read(flashcardProvider.notifier)
                      .setMaxNumberOfCards(number: number);

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FlashcardsPage(
                                topic: topic,
                              )));
                }
              },
              style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.displaySmall),
              child: const Text('Update'),
            )
          ],
        ),
      ),
    );
  }
}
