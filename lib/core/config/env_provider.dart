import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'env.dart';

final envProvider = Provider<Env>((_) => const Env.dev());
