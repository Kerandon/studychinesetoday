import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../configs/app_colors.dart';

class CustomFormChips extends StatelessWidget {
  const CustomFormChips({
    super.key,
    required this.chips,
    required this.initialValue,
    required this.title,
    required this.name,
  });

  final dynamic initialValue;
  final List<FormBuilderChipOption> chips;
  final String title;
  final String name;

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 22, 8, 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.start,
          ),
        ),
        initialValue == 0 ? const SizedBox() : FormBuilderChoiceChip(
          valueTransformer: (dynamic){
            //print(dynamic);
          },
          onChanged: (dynamic){
            //print(dynamic);
          },
            initialValue: initialValue,
            backgroundColor: AppColors.offWhite,
            spacing: 10,
            selectedColor: Colors.amber,
            runSpacing: 10,
            padding: const EdgeInsets.all(8),
            decoration: const InputDecoration(),
            name: name,
            options: chips
        ),
      ],
    );
  }
}
