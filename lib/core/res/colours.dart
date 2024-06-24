import 'dart:ui';

import 'package:flutter/material.dart';

class Colours {
  const Colours._();

  /// #EDF8FF #FDC1E8, #FDFAE1, #FFFFFF
  static const gradient = [
    Color(0xFFEDF8FF),
    Color(0xFFFDC1E8),
    Color(0xFFFFFFFF),
    Color(0xFFFDFAE1),
  ];

  static const subscriptionColours = [
    mathTileColour,
    languageTileColour,
    literatureTileColour,
  ];

  static const subscriptionColoursDarker = [
    Color(0xFFE59995),
    Color(0xFFAADFA4),
    Color(0xFFB191E1),
  ];

  /// #458CFF
  static const primaryColour = Color(0xFF458CFF);

  /// #757C8E
  static const neutralTextColour = Color(0xFF757C8E);

  /// #D3D5FE
  static const physicsTileColour = Color(0xFFD3D5FE);

  /// #FFEFDA
  static const scienceTileColour = Color(0xFFFFEFDA);

  /// #FFE4F1
  static const chemistryTileColour = Color(0xFFFFE4F1);

  /// #CFE5FC
  static const biologyTileColour = Color(0xFFCFE5FC);

  /// #FFCECA
  static const mathTileColour = Color(0xFFFFCECA);

  /// #DAFFD6
  static const languageTileColour = Color(0xFFDAFFD6);

  /// #D5BEFB
  static const literatureTileColour = Color(0xFFD5BEFB);

  /// #FF5C5C
  static const redColour = Color(0xFFFF5C5C);

  /// #28CA6C
  static const greenColour = Color(0xFF28CA6C);

  /// #F4F5F6
  static const chatFieldColour = Color(0xFFF4F5F6);

  /// #E8E9EA
  static const chatFieldColourDarker = Color(0xFFE8E9EA);

  static const currentUserChatBubbleColour = Color(0xFF2196F3);

  static const otherUserChatBubbleColour = Color(0xFFEEEEEE);

  static const currentUserChatBubbleColourDarker = Color(0xFF1976D2);

  static const otherUserChatBubbleColourDarker = Color(0xFFE0E0E0);

  static const int _blackPrimaryValue = 0xFF000000;

  static const MaterialColor primaryBlack = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(_blackPrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );
}
