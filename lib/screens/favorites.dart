import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> _favoritePhrases = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoritePhrases = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _removeFavorite(String phrase) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoritePhrases.remove(phrase);
      prefs.setStringList('favorites', _favoritePhrases);
    });
  }

  void _translate() {
    // Placeholder for translate action
    // Implement your translation logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Translate functionality is not yet implemented')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadFavorites,
          ),
          SizedBox(width: 8), // Add spacing between icons
          TextButton(
            onPressed: _translate,
            child: Text(
              'Translate',
              style: TextStyle(
                color: Colors.white, // Ensure text is visible
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _favoritePhrases.isEmpty
            ? Center(
                child: Text(
                  'No favorite phrases yet',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              )
            : ListView.builder(
                itemCount: _favoritePhrases.length,
                itemBuilder: (context, index) {
                  final phrase = _favoritePhrases[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        phrase,
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          _removeFavorite(phrase);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
