import 'package:flutter_test/flutter_test.dart';
import 'package:user_directory_app/features/users/data/models/user_model.dart';
import 'package:user_directory_app/features/users/domain/entities/user_entity.dart';

void main() {
  const tUserModel = UserModel(
    id: 1,
    email: 'george.bluth@reqres.in',
    firstName: 'George',
    lastName: 'Bluth',
    avatar: 'https://reqres.in/img/faces/1-image.jpg',
    phone: '+1 (555) 019-1001',
  );

  group('UserModel Test Suite', () {
    test('should be a subclass of UserEntity', () {
      expect(tUserModel, isA<UserEntity>());
    });

    test('should parse valid JSON correctly in fromJson', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'email': 'george.bluth@reqres.in',
        'first_name': 'George',
        'last_name': 'Bluth',
        'avatar': 'https://reqres.in/img/faces/1-image.jpg',
        'phone': '+1 (555) 019-1001',
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result.id, equals(1));
      expect(result.firstName, equals('George'));
      expect(result.lastName, equals('Bluth'));
      expect(result.email, equals('george.bluth@reqres.in'));
      expect(result.phone, equals('+1 (555) 019-1001'));
    });

    test('should return a valid JSON map containing proper data in toJson', () {
      final result = tUserModel.toJson();

      final expectedMap = {
        'id': 1,
        'email': 'george.bluth@reqres.in',
        'first_name': 'George',
        'last_name': 'Bluth',
        'avatar': 'https://reqres.in/img/faces/1-image.jpg',
        'phone': '+1 (555) 019-1001',
      };

      expect(result, equals(expectedMap));
    });

    test('should convert to UserEntity using toEntity', () {
      final result = tUserModel.toEntity();
      expect(result, isA<UserEntity>());
      expect(result.id, equals(tUserModel.id));
      expect(result.firstName, equals(tUserModel.firstName));
    });

    test('should parse GitHub style user JSON correctly in fromJson', () {
      final Map<String, dynamic> jsonMap = {
        'login': 'mojombo',
        'id': 1,
        'avatar_url': 'https://avatars.githubusercontent.com/u/1?v=4',
        'html_url': 'https://github.com/mojombo',
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result.id, equals(1));
      expect(result.firstName, equals('mojombo'));
      expect(result.avatar, equals('https://avatars.githubusercontent.com/u/1?v=4'));
      expect(result.email, equals('https://github.com/mojombo'));
    });

    test('should parse ReqRes API user item JSON correctly in fromJson', () {
      final Map<String, dynamic> jsonMap = {
        'id': 2,
        'email': 'janet.weaver@reqres.in',
        'first_name': 'Janet',
        'last_name': 'Weaver',
        'avatar': 'https://reqres.in/img/faces/2-image.jpg'
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result.id, equals(2));
      expect(result.firstName, equals('Janet'));
      expect(result.lastName, equals('Weaver'));
      expect(result.email, equals('janet.weaver@reqres.in'));
      expect(result.avatar, equals('https://reqres.in/img/faces/2-image.jpg'));
    });
  });
}
