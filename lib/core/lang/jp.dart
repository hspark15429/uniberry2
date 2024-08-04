import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// EsLocalizations is a class that provides Spanish labels. We override it here:
class LabelOverrides extends JaLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'Enter your email';

  @override
  String get passwordInputLabel => 'Enter your password';
}
