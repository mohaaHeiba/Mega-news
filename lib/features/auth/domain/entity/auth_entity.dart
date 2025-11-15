class AuthEntity {
  final String id;
  final String name;
  final String email;
  final String? createdAt;

  AuthEntity({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
  });
}
