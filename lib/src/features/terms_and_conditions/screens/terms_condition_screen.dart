import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_app/src/features/terms_and_conditions/logic/terms_condition_provider.dart';
import 'package:ml_app/src/features/terms_and_conditions/widgets/bottom_sheet_widget.dart';
import 'package:ml_app/src/features/terms_and_conditions/widgets/terms_condition_card.dart';
import 'package:ml_app/src/shared/enums/loading_status.dart';
import 'package:ml_app/src/shared/services/translation/translation_service.dart';

class TermsAndConditionScreen extends ConsumerStatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState
    extends ConsumerState<TermsAndConditionScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    ref.read(translationServiceProvider).downloadModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(termsAndConditionProvider.notifier).getTermsAndConditions();
    });
    scrollController.addListener(() {
      //if user has reached near the bottom of the list
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        ref
            .read(termsAndConditionProvider.notifier)
            .loadMoreTermsAndConditions();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(termsAndConditionProvider);
          if (state.loadingStatus == LoadingStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.loadingStatus == LoadingStatus.loaded) {
            return ListView.builder(
              itemCount: state.termsAndConditions.length + 1,
              controller: scrollController,
              itemBuilder: (context, index) {
                if (index == state.termsAndConditions.length) {
                  if (state.loadingMoreStatus == LoadingStatus.loading) {
                    return const Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    );
                  } else if (state.hasReachedMax) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No more terms and conditions'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              showBottomSheet(
                                context: context,
                                builder: (context) => const BottomSheetWidget(),
                              );
                            },
                            child: const Text('Add more'),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                }
                final termsAndCondition = state.termsAndConditions[index];
                return TermsAndConditionCard(
                  termsAndCondition: termsAndCondition,
                );
              },
            );
          } else {
            return const Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }
}
