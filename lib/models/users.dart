class UsersModel {
  String uid;
  String name;
  String email;

  UsersModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  // Method to convert UsersModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  // Method to create UsersModel from a Map (useful for retrieving data)
  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
