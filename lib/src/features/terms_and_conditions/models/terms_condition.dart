class TermsAndCondition {
  final int id;
  final String value;
  final DateTime createdAt;
  final DateTime updatedAt;

  TermsAndCondition({
    required this.id,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TermsAndCondition.fromJson(Map<String, dynamic> json) {
    return TermsAndCondition(
      id: json['id'],
      value: json['value'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
