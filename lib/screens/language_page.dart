import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Function to show the feedback dialog
void showFeedbackDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Submit Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Rate (1-5):'),
            SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                // Handle rating update
                print('Rating: $rating');
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Comments',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Submit feedback logic
              Navigator.of(context).pop();
            },
            child: Text('Submit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}

// Language selection page
class LanguageSelectionPage extends StatelessWidget {
  final List<String> languages = [
    'Spanish',
    'French',
    'Portuguese',
    'English',
    'Italian',
    'Korean',
    'Chinese',
    'German',
    'Japanese',
    'Kiswahili',
    'Arabic'
  ];

  final VoidCallback onToggleDarkMode;

  LanguageSelectionPage({required this.onToggleDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
        backgroundColor: Colors.deepPurple, // AppBar color
        actions: [
          IconButton(
            icon: Icon(Icons.feedback, color: Colors.white),
            onPressed: () => showFeedbackDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.nightlight_round, color: Colors.white),
            onPressed: onToggleDarkMode,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200], // Background color
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.separated(
            itemCount: languages.length,
            separatorBuilder: (context, index) => SizedBox(height: 8.0),
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white, // Card color
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text(
                    languages[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple, // Text color
                    ),
                  ),
                  trailing:
                      Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/language-details',
                      arguments: languages[index],
                    );
                    print(
                        'Navigating to /language-details with language: ${languages[index]}');
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
