import 'package:ai_app/src/features/terms_and_conditions/models/terms_condition.dart';
import 'package:flutter/material.dart';

class TermsAndConditionCard extends StatelessWidget {
  const TermsAndConditionCard({super.key, required this.termsAndCondition});

  final TermsAndCondition termsAndCondition;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          termsAndCondition.value,
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: TextButton(
          onPressed: () {},
          child: const Text('Translate to Hindi'),
        ),
      ),
    );
  }
}
