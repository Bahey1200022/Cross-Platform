import 'package:sarakel/auth/auth_repository.dart';

import 'package:riverpod/riverpod.dart';

final AuthControllerProvider = Provider(
    (ref) => AuthController(authRepository: ref.read(AuthRepositoryProvider)));

class AuthController {
  final AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  void SignInWithGoogle() {
    _authRepository.signInWithGoogle();
  }
}
