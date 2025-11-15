import 'package:mega_news/features/auth/domain/entity/auth_entity.dart';

class AuthModel extends AuthEntity {
  final DateTime? createdAtDate;

  AuthModel({
    required super.id,
    required super.name,
    required super.email,
    this.createdAtDate,
  }) : super(createdAt: createdAtDate?.toIso8601String());

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      createdAtDate: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  /// Convert AuthModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAtDate?.toIso8601String(),
    };
  }

  /// Copy method
  AuthModel copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAtDate,
  }) {
    return AuthModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAtDate: createdAtDate ?? this.createdAtDate,
    );
  }
}
