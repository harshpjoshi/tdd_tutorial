import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/contants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDatasource remoteDatasource;

  setUp(() {
    client = MockClient();
    remoteDatasource = AuthRemoteDataImpl(client);
    registerFallbackValue(Uri());
  });

  group("createUser", () {
    test("should complete successfully when the status code 200 or 201",
        () async {
      // Arrange
      // STUB

      when(() => client.post(any(), body: any(named: "body"))).thenAnswer(
        (_) async => http.Response('User created successfully', 201),
      );

      // ACT
      final methodCall = remoteDatasource.createUser(
        createdAt: "createdAt",
        name: "name",
        avatar: "avatar",
      );

      // Assert
      expect(methodCall, isA<void>());

      verify(
        () => client.post(
          Uri.parse("$baseURL$kCreateUserEndpoint"),
          body: jsonEncode(
            {
              "createdAt": "createdAt",
              "name": "name",
              "avatar": "avatar",
            },
          ),
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });

    test("should throw [APIException] when status code is not 200 or 201",
        () async {
      // Arrange
      // STUB

      when(() => client.post(any(), body: any(named: "body"))).thenAnswer(
        (_) async => http.Response('Invalid email.', 400),
      );

      // ACT
      final methodCall = remoteDatasource.createUser;

      // Assert
      expect(
        () => methodCall(
          createdAt: "createdAt",
          name: "name",
          avatar: "avatar",
        ),
        throwsA(
          const APIException(message: 'Invalid email.', statusCode: 400),
        ),
      );

      verify(
        () => client.post(
          Uri.parse("$baseURL$kCreateUserEndpoint"),
          body: jsonEncode(
            {
              "createdAt": "createdAt",
              "name": "name",
              "avatar": "avatar",
            },
          ),
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });
  });

  group("getUser", () {
    const tUser = [UserModel.empty()];

    test("should return a [List<User>] where statuscode is 200", () async {
      // Arrange
      // STUB

      when(() => client.get(
            any(),
          )).thenAnswer(
        (_) async => http.Response(jsonEncode([tUser.first.toMap()]), 200),
      );

      // ACT
      final result = await remoteDatasource.getUser();

      // Assert

      expect(result, equals(tUser));
      verify(
        () => client.get(
          Uri.parse("$baseURL$kCreateUserEndpoint"),
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });

    test(
      "should throw an exception once remotedatasouce is not having status code 200",
      () async {
        // Arrange
        // STUB

        when(() => client.get(any()))
            .thenAnswer((invocation) async => http.Response('Not found', 400));

        // Act
        final methodCall = remoteDatasource.getUser;

        // Assert
        expect(() => methodCall(),
            throwsA(const APIException(message: "Not found", statusCode: 400)));
        verify(
          () => client.get(
            Uri.parse("$baseURL$kCreateUserEndpoint"),
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );
  });
}
