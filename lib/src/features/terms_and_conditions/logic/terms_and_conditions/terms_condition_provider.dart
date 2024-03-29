import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_app/src/features/terms_and_conditions/logic/terms_and_conditions/terms_condition_state.dart';
import 'package:ml_app/src/features/terms_and_conditions/models/terms_condition.dart';
import 'package:ml_app/src/features/terms_and_conditions/repository/i_terms_condition_repo.dart';
import 'package:ml_app/src/features/terms_and_conditions/repository/terms_condition_repo.dart';
import 'package:ml_app/src/shared/enums/loading_status.dart';
import 'package:ml_app/src/shared/services/translation/i_translation_service.dart';
import 'package:ml_app/src/shared/services/translation/translation_service.dart';

final termsAndConditionProvider =
    StateNotifierProvider<TermsAndConditionProvider, TermsConditionState>(
  (ref) => TermsAndConditionProvider(
    termsAndConditionRepository: ref.read(termsAndConditionRepositoryProvider),
    translationService: ref.read(translationServiceProvider),
  ),
);

class TermsAndConditionProvider extends StateNotifier<TermsConditionState> {
  TermsAndConditionProvider({
    required ITermsAndConditionRepository termsAndConditionRepository,
    required ITranslationService translationService,
  })  : _termsAndConditionRepository = termsAndConditionRepository,
        _translationService = translationService,
        super(TermsConditionState());

  final ITermsAndConditionRepository _termsAndConditionRepository;
  final ITranslationService _translationService;
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
    if (state.hasReachedMax ||
        state.loadingMoreStatus == LoadingStatus.loading) {
      return;
    }
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

  void translateTermsAndConditions({
    required TermsAndCondition termsAndCondition,
  }) async {
    final translation =
        await _translationService.getTranslation(termsAndCondition.value);
    state = state.copyWith(
        termsAndConditions: state.termsAndConditions.map((e) {
      if (e.id == termsAndCondition.id) {
        return e.copyWith(translatedValue: translation);
      }
      return e;
    }).toList());
  }

  void saveTermsAndCondition({
    required String termsAndCondition,
  }) async {
    state = state.copyWith(
      termsAndConditions: [
        ...state.termsAndConditions,
        TermsAndCondition(
          id: state.currentId! + 1,
          value: termsAndCondition,
          translatedValue: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        )
      ],
      currentId: state.currentId! + 1,
    );
  }

  void updateTermsAndCondition({
    required TermsAndCondition termsAndCondition,
    required String value,
  }) async {
    state = state.copyWith(
      termsAndConditions: state.termsAndConditions.map((e) {
        if (e.id == termsAndCondition.id) {
          return e.copyWith(
              value: value, updatedAt: DateTime.now(), translatedValue: null);
        }
        return e;
      }).toList(),
    );
  }
}
