import 'dart:convert';

import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entites/user.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

// Q: What does the class depend on ?
// A: No
// Q: how can we create a fake version of the dependency
// A: No
// Q: how do we control what our dependencies do
// A: No

void main() {
  const tModel = UserModel.empty();

  test("should be a sub class of [User] entity", () {
    //arrange
    //stub

    //act

    //assert
    expect(tModel, isA<User>());
  });

  final tJson = fixture("user.json");
  final tMap = jsonDecode(tJson) as DataMap;

  group("fromMap", () {
    test("should return a [UserModal] with the right", () {
      //Arrange

      //Act
      final result = UserModel.fromMap(tMap);

      //Assert
      expect(result, equals(tModel));
    });
  });

  group("fromJson", () {
    test("should return a [UserModal] with the right", () {
      //Arrange

      //Act
      final result = UserModel.fromJson(tJson);

      //Assert
      expect(result, equals(tModel));
    });
  });

  group("toMap", () {
    test("should return a [Map] with the right", () {
      final result = tModel.toMap();
      expect(result, equals(tMap));
    });
  });

  group("toJson", () {
    test("should return a [JSON] with the right", () {
      final result = tModel.toJson();
      final tsJson = jsonEncode({
        "id": "1",
        "avatar": "_empty.avatar",
        "createdAt": "_empty.createdAt",
        "name": "_empty.name"
      });
      expect(
        result,
        tsJson,
      );
    });
  });

  group("copyWith", () {
    test("should return a [name] with the right", () {
      //Arrange

      //Act
      final result = tModel.copyWith(name: "paul");

      //Assert
      expect(result.name, equals("paul"));
    });
  });
}
