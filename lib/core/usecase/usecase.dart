import 'package:tdd_tutorial/core/utils/typedef.dart';

abstract class UseCaseWithParams<T, Params> {
  ResultFuture<T> call(Params params);
}

abstract class UseCaseWithOutParams<Type> {
  ResultFuture<Type> call();
}
