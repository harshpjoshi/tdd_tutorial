part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CreateUserEvent extends AuthenticationEvent {
  final String createdAt;
  final String name;
  final String avtar;

  const CreateUserEvent({
    required this.name,
    required this.createdAt,
    required this.avtar,
  });

  @override
  List<Object> get props => [name, createdAt, avtar];
}

class GetUserEvent extends AuthenticationEvent {
  const GetUserEvent();
}
