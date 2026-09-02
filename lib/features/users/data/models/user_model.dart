import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';

/// Data Model representing user data transferred over network or local storage.
/// Extends [UserEntity] and handles JSON serialization/deserialization.
@immutable
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.avatar,
    super.phone = '',
  });

  /// Factory constructor to parse raw Map payload into a typed [UserModel].
  /// Handles both ReqRes REST schema and GitHub array schema variations.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int? ?? 0;
    final login = json['login'] as String? ?? '';
    final firstName = (json['first_name'] ?? json['firstName'] ?? login) as String? ?? '';
    final lastName = (json['last_name'] ?? json['lastName']) as String? ?? '';
    final email = (json['email'] ?? json['html_url']) as String? ?? '';
    final avatar = (json['avatar'] ?? json['avatar_url']) as String? ?? '';
    final phoneFromApi = (json['phone'] as String?) ?? '';

    return UserModel(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      avatar: avatar,
      phone: phoneFromApi,
    );
  }

  /// Serializes the model into a JSON-compatible Map representation.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
      'phone': phone,
    };
  }

  /// Converts this [UserModel] instance to a pure [UserEntity].
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      avatar: avatar,
      phone: phone,
    );
  }

  /// Factory constructor to create a [UserModel] from a [UserEntity].
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      avatar: entity.avatar,
      phone: entity.phone,
    );
  }
}
