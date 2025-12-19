import 'package:fisly_mobile/features/auth/application/auth_controller.dart';
import 'package:fisly_mobile/features/auth/application/auth_state.dart';
import 'package:fisly_mobile/features/auth/data/auth_api.dart';
import 'package:fisly_mobile/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/storage/token_store_provider.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(authApiProvider),
    ref.watch(tokenStoreProvider),
  );
});

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
