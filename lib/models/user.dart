class User {
  final int? id;
  final String email;
  final String password;

  User({this.id, required this.email, required this.password});

  // Convert a User into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  // Convert a Map into a User.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
    );
  }
}
