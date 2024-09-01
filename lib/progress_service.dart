import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateProgress(
      String userId, String languageId, int increment) async {
    DocumentReference languageProgressDoc = _usersCollection
        .doc(userId)
        .collection('languageProgress')
        .doc(languageId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(languageProgressDoc);

      if (!snapshot.exists) {
        transaction.set(languageProgressDoc, {
          'progress': increment,
        });
      } else {
        int newProgress = snapshot['progress'] + increment;
        transaction.update(languageProgressDoc, {
          'progress': newProgress,
        });
      }
    });
  }
}
