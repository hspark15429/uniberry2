import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/src/auth/domain/entities/user.dart';

extension ContextExt on BuildContext {
  LocalUser? get currentUser => read<UserProvider>().user;
}
