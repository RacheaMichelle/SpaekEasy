import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LanguageLearningPage extends StatelessWidget {
  final String languageId;

  LanguageLearningPage({required this.languageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn $languageId'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('languages')
            .doc(languageId)
            .collection('phrases')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No phrases available.'));
          }

          final phrases = snapshot.data!.docs;

          return ListView.builder(
            itemCount: phrases.length,
            itemBuilder: (context, index) {
              final phraseData = phrases[index];
              final phrase = phraseData['text'] ?? 'Unknown';
              final pronunciation = phraseData['pronunciation'] ?? 'Unknown';

              return ListTile(
                title: Text(phrase),
                subtitle: Text(pronunciation),
              );
            },
          );
        },
      ),
    );
  }
}
