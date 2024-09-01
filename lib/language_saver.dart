import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Language Saver')),
        body: LanguageSaver(),
      ),
    );
  }
}

class LanguageSaver extends StatefulWidget {
  @override
  _LanguageSaverState createState() => _LanguageSaverState();
}

class _LanguageSaverState extends State<LanguageSaver> {
  final firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    saveAllLanguages();
  }

  Future<void> saveAllLanguages() async {
    try {
      await firestoreService.savePortuguese();
      await firestoreService.saveFrench();
      await firestoreService.saveSpanish();
      await firestoreService.saveKorean();
      await firestoreService.saveItalian();
      await firestoreService.saveGerman();
      await firestoreService.saveJapanese();
      await firestoreService.saveChinese();

      // Continue with other languages as needed
      print("All languages saved successfully!");
    } catch (e) {
      print("Failed to save languages: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Saving languages to Firestore...'),
    );
  }
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> savePortuguese() async {
    // Save Portuguese language data
    await _db
        .collection('languages')
        .doc('portuguese')
        .set({'name': 'Portuguese'});
  }

  Future<void> saveFrench() async {
    // Save French language data
    await _db.collection('languages').doc('french').set({'name': 'French'});
  }

  Future<void> saveSpanish() async {
    // Save Spanish language data
    await _db.collection('languages').doc('spanish').set({'name': 'Spanish'});
  }

  Future<void> saveKorean() async {
    // Save Korean language data
    await _db.collection('languages').doc('korean').set({'name': 'Korean'});
  }

  Future<void> saveItalian() async {
    // Save Italian language data
    await _db.collection('languages').doc('italian').set({'name': 'Italian'});
  }

  Future<void> saveGerman() async {
    // Save German language data
    await _db.collection('languages').doc('german').set({'name': 'German'});
  }

  Future<void> saveJapanese() async {
    // Save Spanish language data
    await _db.collection('languages').doc('japanese').set({'name': 'Japanese'});
  }

  Future<void> saveChinese() async {
    // Save Spanish language data
    await _db.collection('languages').doc('chinese').set({'name': 'Chinese'});
  }

  Future<void> saveKiswahili() async {
    // Save Italian language data
    await _db
        .collection('languages')
        .doc('kiswahili')
        .set({'name': 'Kiswahili'});
  }

  Future<void> saveArabic() async {
    // Save Italian language data
    await _db.collection('languages').doc('arabic').set({'name': 'Arabic'});
  }

  Future<void> saveEnglish() async {
    // Save Italian language data
    await _db.collection('languages').doc('english').set({'name': 'English'});
  }
}
