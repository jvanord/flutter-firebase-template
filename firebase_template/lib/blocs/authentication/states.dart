import 'package:equatable/equatable.dart';
import 'package:firebase_template/services/authentication_service.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final UserInfo user;
  const Authenticated(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Authenticated: \'${user.name}\'';
}

class Unauthenticated extends AuthenticationState {}
