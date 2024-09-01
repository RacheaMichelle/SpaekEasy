import 'package:flutter/material.dart';
import 'package:language_learning_assistant/auth_service.dart';
import 'package:language_learning_assistant/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites.dart';
import 'phrase_search_delegate.dart';

class AnimatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  AnimatedButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.deepPurple, // Background color
          backgroundColor: Colors.white, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class LanguageDetailsPage extends StatefulWidget {
  @override
  _LanguageDetailsPageState createState() => _LanguageDetailsPageState();
}

class _LanguageDetailsPageState extends State<LanguageDetailsPage> {
  final FirestoreService _firestore = FirestoreService();
  final AuthService _auth = AuthService();

  String? _translatedPhrase;
  final TextEditingController _phraseController = TextEditingController();
  bool _isFavorited = false;
  List<String> _favoritePhrases = [];
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadPhrases();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoritePhrases = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _loadPhrases() async {
    final Object? argument = ModalRoute.of(context)?.settings.arguments;
    final String? language = argument is String ? argument : null;

    if (language != null) {
      final data = await _firestore.getLanguageDetails(language);
      if (data != null) {
        setState(() {
          _searchResults = data.keys.toList().cast<String>();
        });
      }
    }
  }

  Future<void> _toggleFavorite(String phrase) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoritePhrases.contains(phrase)) {
        _favoritePhrases.remove(phrase);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from favorites')),
        );
      } else {
        _favoritePhrases.add(phrase);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites')),
        );
      }
      prefs.setStringList('favorites', _favoritePhrases);
    });
  }

  Future<void> _navigateToFavoritesPage() async {
    final updatedFavorites = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesPage(),
      ),
    );

    if (updatedFavorites != null) {
      setState(() {
        _favoritePhrases = List<String>.from(updatedFavorites);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Object? argument = ModalRoute.of(context)?.settings.arguments;
    final String? language = argument is String ? argument : null;

    if (language == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(child: Text('Language not provided')),
      );
    }

    final User? user = _auth.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text(language),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: _navigateToFavoritesPage,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PhraseSearchDelegate(_searchResults),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null) ...[
                FutureBuilder<Map<String, dynamic>?>(
                  future: _firestore.getLanguageDetails(language),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['description'] ?? 'No description available',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                          child: Text('No data available',
                              style: TextStyle(color: Colors.white)));
                    }
                  },
                ),
                SizedBox(height: 20),
              ] else
                Center(
                    child: Text('No user signed in',
                        style: TextStyle(color: Colors.white))),

              // TextField for entering the phrase
              TextField(
                controller: _phraseController,
                decoration: InputDecoration(
                  labelText: 'Enter a phrase to translate',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 102, 27, 124)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorited ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorited = !_isFavorited;
                        _toggleFavorite(_phraseController.text);
                      });
                    },
                  ),
                ),
                style: TextStyle(color: Colors.black),
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    // Translate the phrase
                    String? translatedPhrase =
                        await _firestore.translatePhrase(language, value);
                    setState(() {
                      _translatedPhrase =
                          translatedPhrase ?? 'Translation not found';
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              AnimatedButton(
                onPressed: () async {
                  if (_phraseController.text.isNotEmpty) {
                    // Translate the phrase
                    String? translatedPhrase = await _firestore.translatePhrase(
                        language, _phraseController.text);
                    setState(() {
                      _translatedPhrase =
                          translatedPhrase ?? 'Translation not found';
                    });
                  }
                },
                text: 'Translate',
              ),
              SizedBox(height: 20),

              // Display the translated phrase
              if (_translatedPhrase != null)
                Text('Translation: $_translatedPhrase',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromARGB(255, 229, 4, 237))),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phraseController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
