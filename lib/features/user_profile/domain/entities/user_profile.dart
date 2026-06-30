class UserProfile {
  final String uid;
  final String username;
  final String email;
  final DateTime createdAt;

  const UserProfile({
    required this.uid,
    required this.username,
    required this.email,
    required this.createdAt,
  });
}
