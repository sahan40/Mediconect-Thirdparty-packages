class MedicationItem {
  final String id;
  final String name;
  final String dosage;
  final String frequency;

  const MedicationItem({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
  });

  String get subtitle => '$dosage · $frequency';
}

class MedicalHistoryModel {
  final List<String> chronicConditions;
  final String pastSurgeries;
  final List<MedicationItem> medications;

  const MedicalHistoryModel({
    this.chronicConditions = const [],
    this.pastSurgeries = '',
    this.medications = const [],
  });

  MedicalHistoryModel copyWith({
    List<String>? chronicConditions,
    String? pastSurgeries,
    List<MedicationItem>? medications,
  }) {
    return MedicalHistoryModel(
      chronicConditions: chronicConditions ?? this.chronicConditions,
      pastSurgeries:     pastSurgeries     ?? this.pastSurgeries,
      medications:       medications       ?? this.medications,
    );
  }
}