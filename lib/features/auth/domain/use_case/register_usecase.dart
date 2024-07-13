import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../repository/auth_repository.dart';

final registerUseCaseProvider = Provider<RegisterUseCase>(
  (ref) => RegisterUseCase(ref.read(authRepositoryProvider)),
);

class RegisterUseCase {
  final IAuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, bool>> registerUser(String fullName, String email,
      String password, String address, String username, String mobileNo) {
    return repository.registerUser(
        fullName, email, password, address, username, mobileNo);
  }
}
