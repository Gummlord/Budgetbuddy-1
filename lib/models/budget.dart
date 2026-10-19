/// Daily / Weekly / Monthly budget amounts for a user.
class Budget {
  final double daily;
  final double weekly;
  final double monthly;
  final DateTime? updatedAt;

  const Budget({
    this.daily = 0,
    this.weekly = 0,
    this.monthly = 0,
    this.updatedAt,
  });

  bool get isEmpty => daily == 0 && weekly == 0 && monthly == 0;

  factory Budget.fromMap(Map<String, dynamic> map) {
    double toDouble(dynamic v) => (v is num) ? v.toDouble() : 0;
    return Budget(
      daily: toDouble(map['daily']),
      weekly: toDouble(map['weekly']),
      monthly: toDouble(map['monthly']),
      updatedAt: map['updatedAt'] is String
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'daily': daily,
    'weekly': weekly,
    'monthly': monthly,
    'updatedAt': DateTime.now().toIso8601String(),
  };
}
