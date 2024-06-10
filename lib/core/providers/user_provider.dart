import 'package:flutter/widgets.dart';
import 'package:uniberry2/src/auth/domain/entities/user.dart';

class UserProvider extends ChangeNotifier {
  LocalUser? _user;

  LocalUser? get user => _user;

  void initUser(LocalUser? user) {
    if (_user != user) {
      _user = user;
    }
  }

  set user(LocalUser? user) {
    if (_user != user) {
      _user = user;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }
}
