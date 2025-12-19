import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'secure_storage_provider.dart';
import 'token_store.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) {
  return TokenStore(ref.watch(secureStorageProvider));
});
