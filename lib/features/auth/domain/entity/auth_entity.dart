import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String username;
  final String? messages;
  final String password;
  final bool succeeded;

  const AuthEntity(
      {required this.username,
      this.messages,
      required this.password,
      required this.succeeded});

  @override
  List<Object?> get props => [username, password, succeeded, messages];
}
