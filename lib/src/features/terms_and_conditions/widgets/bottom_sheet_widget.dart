import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_app/src/features/terms_and_conditions/logic/speech_to_text_provider.dart';
import 'package:ml_app/src/features/terms_and_conditions/logic/terms_condition_provider.dart';
import 'package:ml_app/src/features/terms_and_conditions/models/terms_condition.dart';

class BottomSheetWidget extends ConsumerStatefulWidget {
  const BottomSheetWidget({super.key, this.termsAndCondition});

  final TermsAndCondition? termsAndCondition;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends ConsumerState<BottomSheetWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.termsAndCondition != null) {
      textEditingController.text = widget.termsAndCondition!.value;
    }
    ref.read(speechToTextProvider.notifier).initSpeech();
  }

  final textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdate = widget.termsAndCondition != null;
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: EdgeInsets.only(bottom: bottom != 0 ? bottom - 5 : bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
          ),
        ],
      ),
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16, width: double.infinity),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: 'Enter new term and condition',
                suffixIcon: IconButton(
                  onPressed: () async {
                    ref.read(speechToTextProvider.notifier).startListening();
                    final textFromSpeech = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Speech to text'),
                        content: Consumer(
                          builder: (context, ref, child) => Text(
                            ref.watch(speechToTextProvider).$1,
                          ),
                        ),
                        actions: [
                          Consumer(
                            builder: (context, ref, child) => TextButton(
                              onPressed: ref.watch(speechToTextProvider).$2
                                  ? null
                                  : () {
                                      Navigator.pop(context,
                                          ref.watch(speechToTextProvider).$1);
                                    },
                              child: const Text('Submit'),
                            ),
                          )
                        ],
                      ),
                    );
                    textEditingController.text = textFromSpeech ?? '';
                  },
                  icon: const Icon(Icons.mic),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (textEditingController.text.isNotEmpty) {
                  isUpdate ? update(context) : save(context);
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  void save(BuildContext context) {
    if (textEditingController.text.isNotEmpty) {
      ref
          .read(termsAndConditionProvider.notifier)
          .saveTermsAndCondition(termsAndCondition: textEditingController.text);
      Navigator.pop(context);
    }
  }

  void update(BuildContext context) {
    if (textEditingController.text.isNotEmpty) {
      ref.read(termsAndConditionProvider.notifier).updateTermsAndCondition(
          termsAndCondition: widget.termsAndCondition!,
          value: textEditingController.text);
      Navigator.pop(context);
    }
  }
}
