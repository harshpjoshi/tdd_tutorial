import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/entites/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:test/test.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers usecases;

  setUp(() {
    repository = MockAuthRepository();
    usecases = GetUsers(repository);
  });

  const response = [User.empty()];

  test("should call the [AuthRepo.getUsers] and retuen [List<User>]", () async {
    //Arrange
    //STUB
    when(() => repository.gtUsers())
        .thenAnswer((invocation) async => const Right(response));

    // Act
    final result = await usecases();

    // Assert
    expect(
      result,
      equals(
        const Right<dynamic, List<User>>(response),
      ),
    );

    verify(() => repository.gtUsers()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
