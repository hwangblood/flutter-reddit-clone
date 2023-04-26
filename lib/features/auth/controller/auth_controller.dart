import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/core/utils/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(authRepository: ref.read(authRepositoryProvider));
});

class AuthController {
  final AuthRepository _authRepository;

  AuthController({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<void> signInWithGoogle(BuildContext context) async {
    final user = await _authRepository.signInWithGoogle();
    user.fold(
      (l) => SnackBarUtil.showSnackBar(context, message: l.message),
      (r) => null,
    );
  }
}
