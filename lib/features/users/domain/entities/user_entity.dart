import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing a User in the business layer.
/// Extends [Equatable] for explicit value equality comparisons.
class UserEntity extends Equatable {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;
  final String phone;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    this.phone = '',
  });

  @override
  List<Object?> get props => [id, email, firstName, lastName, avatar, phone];
}
