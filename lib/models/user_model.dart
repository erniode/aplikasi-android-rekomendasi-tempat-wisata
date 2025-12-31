class UserModel {
  // ID pengguna dari Firebase Auth
  final String uid;
  // Username yang digunakan untuk login
  final String username;
  // Peran: 'user' atau 'admin'
  final String role;
  // Informasi profil tambahan
  final String name;
  final int age;
  final String gender;
  final String profilePictureUrl;

  UserModel({
    required this.uid,
    required this.username,
    required this.role,
    this.name = '',
    this.age = 0,
    this.gender = '',
    this.profilePictureUrl = '',
  });

  // Metode untuk mengkonversi UserModel menjadi Map (untuk disimpan di Firestore)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'role': role,
      'name': name,
      'age': age,
      'gender': gender,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  // Metode untuk membuat UserModel dari DocumentSnapshot Firestore
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      username: map['username'] as String,
      role: map['role'] as String,
      name: map['name'] as String? ?? '',
      age: map['age'] as int? ?? 0,
      gender: map['gender'] as String? ?? '',
      profilePictureUrl: map['profilePictureUrl'] as String? ?? '',
    );
  }

  // Method to create a copy with updated fields
  UserModel copyWith({
    String? uid,
    String? username,
    String? role,
    String? name,
    int? age,
    String? gender,
    String? profilePictureUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      role: role ?? this.role,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }
}
