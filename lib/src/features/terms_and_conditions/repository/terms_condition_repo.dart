import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_app/src/features/terms_and_conditions/models/terms_condition.dart';
import 'package:ml_app/src/features/terms_and_conditions/repository/i_terms_condition_repo.dart';

final termsAndConditionRepositoryProvider =
    Provider<ITermsAndConditionRepository>(
  (ref) => TermsAndConditionRepository(),
);

final class TermsAndConditionRepository
    implements ITermsAndConditionRepository {
  @override
  Future<List<TermsAndCondition>> getTermsAndConditions() async {
    await Future.delayed(const Duration(seconds: 2));
    final data =
        await rootBundle.loadString('assets/terms_and_conditions.json');
    final termsAndConditions = (json.decode(data) as List)
        .map((e) => TermsAndCondition.fromJson(e))
        .toList();
    // .sublist(0, 5);
    return termsAndConditions;
  }

  @override
  Future<List<TermsAndCondition>> loadMoreTermsAndConditions(
      int currentId) async {
    await Future.delayed(const Duration(seconds: 1));
    final data =
        await rootBundle.loadString('assets/terms_and_conditions.json');
    final termsAndConditions = (json.decode(data) as List)
        .where((element) => element['id'] == currentId)
        .map((e) => TermsAndCondition.fromJson(e))
        .toList();
    return termsAndConditions;
  }

  @override
  Future<bool> saveTermsAndCondition(TermsAndCondition termsAndCondition) {
    // TODO: implement saveTermsAndCondition
    throw UnimplementedError();
  }
}
