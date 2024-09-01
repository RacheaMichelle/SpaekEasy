// phrase.dart
class PhraseModel {
  String id;
  String text;
  String translation;
  String languageId;

  PhraseModel({
    required this.id,
    required this.text,
    required this.translation,
    required this.languageId,
  });

  // Method to convert PhraseModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'translation': translation,
      'languageId': languageId,
    };
  }

  // Method to create PhraseModel from a Map (useful for retrieving data)
  factory PhraseModel.fromMap(Map<String, dynamic> map) {
    return PhraseModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      translation: map['translation'] ?? '',
      languageId: map['languageId'] ?? '',
    );
  }
}
