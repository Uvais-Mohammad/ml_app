import 'package:ai_app/src/features/terms_and_conditions/models/terms_condition.dart';
import 'package:ai_app/src/shared/enums/loading_status.dart';

class TermsConditionState {
  final List<TermsAndCondition> termsAndConditions;
  final LoadingStatus loadingStatus;
  final LoadingStatus loadingMoreStatus;
  final bool hasReachedMax;
  final String? errorMessage;
  final int? currentId;
  TermsConditionState({
    this.termsAndConditions = const [],
    this.loadingStatus = LoadingStatus.initial,
    this.loadingMoreStatus = LoadingStatus.initial,
    this.hasReachedMax = false,
    this.errorMessage,
    this.currentId,
  });

  TermsConditionState copyWith({
    List<TermsAndCondition>? termsAndConditions,
    LoadingStatus? loadingStatus,
    LoadingStatus? loadingMoreStatus,
    bool? hasReachedMax,
    String? errorMessage,
    int? currentId,
  }) {
    return TermsConditionState(
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingMoreStatus: loadingMoreStatus ?? this.loadingMoreStatus,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      currentId: currentId ?? this.currentId,
    );
  }
}
