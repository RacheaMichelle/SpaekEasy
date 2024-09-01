import 'package:flutter/material.dart';
import 'package:language_learning_assistant/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatelessWidget {
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.deepPurple, // AppBar color
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _firestore.getUserProfile(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red)));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No data found',
                    style: TextStyle(color: Colors.grey)));
          }

          final userData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Profile Header
                Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      userData['name'] != null ? userData['name']![0] : 'U',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Name
                Text(
                  'Name:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Text(
                  userData['name'] ?? 'No name provided',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
                SizedBox(height: 20),
                // Email
                Text(
                  'Email:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Text(
                  userData['email'] ?? 'No email provided',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
                SizedBox(height: 20),
                // Created At
                Text(
                  'Created At:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Text(
                  userData['createdAt'] != null
                      ? '${userData['createdAt'].toDate()}'
                      : 'No date provided',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
