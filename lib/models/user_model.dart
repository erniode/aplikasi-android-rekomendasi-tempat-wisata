class UserModel {
  // ID pengguna dari Firebase Auth
  final String uid;
  // Username yang digunakan untuk login
  final String username;
  // Peran: 'user' atau 'admin'
  final String role;

  UserModel({
    required this.uid,
    required this.username,
    required this.role,
  });

  // Metode untuk mengkonversi UserModel menjadi Map (untuk disimpan di Firestore)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'role': role,
    };
  }

  // Metode untuk membuat UserModel dari DocumentSnapshot Firestore
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      username: map['username'] as String,
      role: map['role'] as String,
    );
  }
}
