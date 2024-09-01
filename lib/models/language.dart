class LanguageModel {
  final String languageId;
  final String name;
  final String description;

  LanguageModel({
    required this.languageId,
    required this.name,
    required this.description,
  });

  // Convert LanguageModel to Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'languageId': languageId,
      'name': name,
      'description': description,
    };
  }

  // Create LanguageModel from Firestore document
  factory LanguageModel.fromMap(Map<String, dynamic> map) {
    return LanguageModel(
      languageId: map['languageId'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }
}
