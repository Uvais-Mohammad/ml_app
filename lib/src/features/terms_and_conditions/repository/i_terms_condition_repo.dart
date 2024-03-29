import 'package:ml_app/src/features/terms_and_conditions/models/terms_condition.dart';

abstract interface class ITermsAndConditionRepository {
  Future<List<TermsAndCondition>> getTermsAndConditions();
  Future<List<TermsAndCondition>> loadMoreTermsAndConditions(int currentId);
}
