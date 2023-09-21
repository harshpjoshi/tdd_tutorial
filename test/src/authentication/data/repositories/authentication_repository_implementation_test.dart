import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_implementaion.dart';
import 'package:tdd_tutorial/src/authentication/domain/entites/user.dart';

class MockAuthRemoteDataSourceImpl extends Mock
    implements AuthenticationRemoteDatasource {}

void main() {
  late AuthenticationRemoteDatasource remoteDatasource;
  late AuthenticationRepositoryImplementation repositoryImplementation;

  setUp(() {
    remoteDatasource = MockAuthRemoteDataSourceImpl();
    repositoryImplementation =
        AuthenticationRepositoryImplementation(remoteDatasource);
  });

  group("createUser", () {
    const createdAt = "whatever.createdAt";
    const name = "whatever.name";
    const avatar = "whatever.avatar";

    const tException =
        APIException(message: "Unknown Error Occured", statusCode: 500);

    test(
        'should call the [RemoteDataSource.createUser] and complete successfully'
        'when the call to the remote source successful', () async {
      // arrange
      when(() => remoteDatasource.createUser(
              createdAt: any(named: "createdAt"),
              name: any(named: "name"),
              avatar: any(named: "avatar")))
          .thenAnswer((invocation) async => Future.value());

      // act

      final result = await repositoryImplementation.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      // assert
      expect(
        result,
        equals(
          const Right(null),
        ),
      );
      verify(
        () => remoteDatasource.createUser(
            createdAt: createdAt, name: name, avatar: avatar),
      ).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });

    test(
        'should return a [APIFailure] '
        'when the call to the remote source un-successful', () async {
      // arrange
      // stub

      when(() => remoteDatasource.createUser(
          createdAt: any(named: "createdAt"),
          name: any(named: "name"),
          avatar: any(named: "avatar"))).thenThrow(tException);

      // act

      final result = await repositoryImplementation.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      // assert
      expect(
        result,
        equals(
          Left(
            APIFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      verify(
        () => remoteDatasource.createUser(
            createdAt: createdAt, name: name, avatar: avatar),
      ).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group("getUser", () {
    test(
        'should call the [RemoteDataSource.getUser] and complete successfully'
        'when the call to the remote source successful', () async {
      // Arrange
      // Stub
      const expectUsers = [UserModel.empty()];
      when(
        () => remoteDatasource.getUser(),
      ).thenAnswer(
        (_) async => expectUsers,
      );

      //act
      final result = await repositoryImplementation.gtUsers();

      // assert
      expect(result, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDatasource.getUser()).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test(
        'should return a [APIFailure] '
        'when the call to the remote source un-successful', () async {
      // arrange
      // stub
      const tException =
          APIException(message: "Unknown Error Occured", statusCode: 500);
      when(() => remoteDatasource.getUser()).thenThrow(tException);

      // act

      final result = await repositoryImplementation.gtUsers();

      // assert
      expect(
        result,
        equals(
          Left(
            APIFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      verify(
        () => remoteDatasource.getUser(),
      ).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });
}
