import 'package:care_app_flutter/core/failure/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/auth_remote_repo_impl.dart';

final authRepositoryProvider = Provider<IAuthRepository>(
  (ref) => ref.read(authRemoteRepositoryProvider),
);
abstract class IAuthRepository {
  Future<Either<Failure, bool>> loginStaff(String username, String password);
}
