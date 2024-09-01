import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:language_learning_assistant/models/language.dart';

class LanguageService {
  final CollectionReference _languagesCollection =
      FirebaseFirestore.instance.collection('languages');

  Future<List<LanguageModel>> getLanguages() async {
    QuerySnapshot snapshot = await _languagesCollection.get();
    return snapshot.docs.map((doc) {
      return LanguageModel(
        languageId: doc.id,
        name: doc['name'],
        description: doc['description'],
      );
    }).toList();
  }
}
