class LanguageProgressModel {
  final String languageId;
  final List<String> completedPhrases;
  double progress;

  LanguageProgressModel({
    required this.languageId,
    required this.completedPhrases,
    required this.progress,
  });

  // Convert LanguageProgressModel to Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'languageId': languageId,
      'completedPhrases': completedPhrases,
      'progress': progress,
    };
  }

  // Create LanguageProgressModel from Firestore document
  factory LanguageProgressModel.fromMap(Map<String, dynamic> map) {
    return LanguageProgressModel(
      languageId: map['languageId'] as String,
      completedPhrases: List<String>.from(map['completedPhrases'] as List),
      progress: map['progress'] as double,
    );
  }
}
