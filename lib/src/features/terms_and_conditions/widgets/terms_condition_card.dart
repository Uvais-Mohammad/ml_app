import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_app/src/features/terms_and_conditions/logic/terms_condition_provider.dart';
import 'package:ml_app/src/features/terms_and_conditions/models/terms_condition.dart';
import 'package:ml_app/src/features/terms_and_conditions/widgets/bottom_sheet_widget.dart';

class TermsAndConditionCard extends ConsumerWidget {
  const TermsAndConditionCard({super.key, required this.termsAndCondition});

  final TermsAndCondition termsAndCondition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => BottomSheetWidget(
              termsAndCondition: termsAndCondition,
            ),
          );
        },
        contentPadding: const EdgeInsets.all(16),
        title: Column(
          children: [
            Text(
              termsAndCondition.value,
              style: const TextStyle(fontSize: 20),
            ),
            if (termsAndCondition.translatedValue != null)
              const SizedBox(height: 16),
            Text(
              termsAndCondition.translatedValue ?? '',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            const Spacer(),
            TextButton(
              onPressed: () {
                if (termsAndCondition.translatedValue == null) {
                  ref
                      .read(termsAndConditionProvider.notifier)
                      .translateTermsAndConditions(
                        termsAndCondition: termsAndCondition,
                      );
                }
              },
              child: const Text('View in Hindi'),
            ),
          ],
        ),
      ),
    );
  }
}
