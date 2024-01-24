import 'package:ai_app/src/features/terms_and_conditions/logic/terms_condition_provider.dart';
import 'package:ai_app/src/features/terms_and_conditions/widgets/terms_condition_card.dart';
import 'package:ai_app/src/shared/enums/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(termsAndConditionProvider.notifier).getTermsAndConditions();
    });
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          ref
              .read(termsAndConditionProvider.notifier)
              .loadMoreTermsAndConditions();
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
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
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('No more terms and conditions'),
                      ),
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