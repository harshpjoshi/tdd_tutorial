import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/domain/entites/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  AuthenticationRepositoryImplementation(this._remoteDataSource);

  final AuthenticationRemoteDatasource _remoteDataSource;

  @override
  ResultVoid createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    // Test Driven Development
    // call the remote data source
    // check if method returns proper data
    // make sure that it return the proper data if there is no exception
    // check if when the remoteDatasource throws an exception, we return a failure

    try {
      await _remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      return const Right(null);
    } on APIException catch (e) {
      return Left(
        APIFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<List<User>> gtUsers() async {
    try{
      final result = await _remoteDataSource.getUser();
      return Right(result);
    } on APIException catch(e){
      return Left(APIFailure.fromException(e),);
    }
  }
}
