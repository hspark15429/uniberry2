import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/src/auth/domain/entities/user.dart';

extension ContextExt on BuildContext {
  LocalUser? get currentUser => read<UserProvider>().user;
}
