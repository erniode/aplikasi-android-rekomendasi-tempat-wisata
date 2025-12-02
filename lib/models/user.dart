class UserModel {
  final int id;
  final String username;
  final String password; // NOTE: in production, NEVER store plaintext passwords

  UserModel({required this.id, required this.username, required this.password});
}
