import 'package:ai_app/src/features/terms_and_conditions/logic/terms_condition_state.dart';
import 'package:ai_app/src/features/terms_and_conditions/repository/i_terms_condition_repo.dart';
import 'package:ai_app/src/features/terms_and_conditions/repository/terms_condition_repo.dart';
import 'package:ai_app/src/shared/enums/loading_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final termsAndConditionProvider =
    StateNotifierProvider<TermsAndConditionProvider, TermsConditionState>(
  (ref) => TermsAndConditionProvider(
    termsAndConditionRepository: ref.read(termsAndConditionRepositoryProvider),
  ),
);

class TermsAndConditionProvider extends StateNotifier<TermsConditionState> {
  TermsAndConditionProvider({
    required ITermsAndConditionRepository termsAndConditionRepository,
  })  : _termsAndConditionRepository = termsAndConditionRepository,
        super(TermsConditionState());

  final ITermsAndConditionRepository _termsAndConditionRepository;

  void getTermsAndConditions() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    final termsAndConditions =
        await _termsAndConditionRepository.getTermsAndConditions();

    state = state.copyWith(
      termsAndConditions: termsAndConditions,
      loadingStatus: LoadingStatus.loaded,
      currentId: termsAndConditions.last.id,
    );
  }

  void loadMoreTermsAndConditions() async {
    if (state.hasReachedMax) return;
    state = state.copyWith(loadingMoreStatus: LoadingStatus.loading);
    final termsAndConditions = await _termsAndConditionRepository
        .loadMoreTermsAndConditions(state.currentId! + 1);
    state = state.copyWith(
      termsAndConditions: [...state.termsAndConditions, ...termsAndConditions],
      loadingMoreStatus: LoadingStatus.loaded,
      currentId: termsAndConditions.last.id,
      hasReachedMax: termsAndConditions.last.id == 7618,
    );
  }
}
