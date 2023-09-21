import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const apiFailure = APIFailure(message: "message", statusCode: 400);

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => cubit.close());

  test("initialState should be [AuthenticationInitial]", () async {
    expect(cubit.state, AuthenticationInitial());
  });

  group("createUser", () {
    blocTest<AuthenticationCubit, AuthenticationState>(
        "should emit [CreatingUser, UserCreated] when successful",
        build: () {
          when(() => createUser(any())).thenAnswer(
            (_) async => const Right(null),
          );

          return cubit;
        },
        act: (cubit) => cubit.createUser(
              createdAt: tCreateUserParams.createdAt,
              name: tCreateUserParams.name,
              avatar: tCreateUserParams.avatar,
            ),
        expect: () => [
              const CreatingUser(),
              const UserCreated(),
            ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);

          verifyNoMoreInteractions(createUser);
        });

    blocTest<AuthenticationCubit, AuthenticationState>(
        "should emit [CreatingUser, AuthenticationError] when un-successful",
        build: () {
          when(() => createUser(any())).thenAnswer(
            (_) async => const Left(apiFailure),
          );

          return cubit;
        },
        act: (cubit) => cubit.createUser(
              createdAt: tCreateUserParams.createdAt,
              name: tCreateUserParams.name,
              avatar: tCreateUserParams.avatar,
            ),
        expect: () => [
              const CreatingUser(),
              AuthenticationError(apiFailure.errorMessage),
            ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);

          verifyNoMoreInteractions(createUser);
        });
  });

  group("getUsers", () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      "should emit [GettingUser, UserLoaded] when successful",
      build: () {
        when(() => getUsers()).thenAnswer(
          (_) async => const Right(
            [],
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => const [
        GettingUser(),
        UsersLoaded(
          [],
        ),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );

    blocTest(
      "should emit [GettingUser, AuthenticationError] when un-successful",
      build: () {
        when(() => getUsers()).thenAnswer(
          (_) async => const Left(apiFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => [
        const GettingUser(),
        AuthenticationError(apiFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
