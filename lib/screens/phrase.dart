import 'package:flutter/material.dart';
import 'package:language_learning_assistant/models/language.dart';
import 'package:language_learning_assistant/models/phrase.dart';
import 'package:language_learning_assistant/firestore_service.dart';

class PhrasesPage extends StatefulWidget {
  final LanguageModel language;

  PhrasesPage({required this.language});

  @override
  _PhrasesPageState createState() => _PhrasesPageState();
}

class _PhrasesPageState extends State<PhrasesPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<PhraseModel> phrases = [];
  String translatedText = '';

  @override
  void initState() {
    super.initState();
    fetchPhrases();
  }

  Future<void> fetchPhrases() async {
    // Use languageId instead of id
    phrases = await _firestoreService.getPhrases(widget.language.languageId);
    setState(() {});
  }

  void translatePhrase(String input) {
    setState(() {
      translatedText = phrases
          .firstWhere(
              (phrase) => phrase.text.toLowerCase() == input.toLowerCase(),
              orElse: () => PhraseModel(
                    id: '',
                    text: '',
                    translation: 'No translation found',
                    languageId: widget.language.languageId,
                  ))
          .translation;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Phrases in ${widget.language.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.language.description),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter phrase to translate',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                translatePhrase(_controller.text);
              },
              child: Text('Translate'),
            ),
            SizedBox(height: 20),
            Text(
              'Translation: $translatedText',
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: phrases.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(phrases[index].text),
                    subtitle:
                        Text('Translation: ${phrases[index].translation}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
