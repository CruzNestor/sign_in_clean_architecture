import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:signin_and_signup/src/features/auth/data/models/user_model.dart';
import 'package:signin_and_signup/src/features/auth/domain/entities/user.dart';

import '../../../../../fixtures/fixture_reader.dart';

void main() {
  group('UserModel', () {
    final Map<String, dynamic> tJSON = json.decode(fixture('user.json'));
    final tUserModel = UserModel.fromJSON(tJSON);

    test('model should be a subclass of entity', () {
      expect(tUserModel, isA<User>());
    });

    test('Should return a validate model', () {
      final result = UserModel.fromJSON(tJSON);
      expect(result, tUserModel);
    });
  });
}