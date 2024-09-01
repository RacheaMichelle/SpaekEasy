import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart'; // Adjust the import based on your project structure

Future<void> main() async {
  await Firebase.initializeApp();

  final firestoreService = FirestoreService();
  await firestoreService.populateLanguages();
}
