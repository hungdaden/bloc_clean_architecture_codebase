import 'package:flutter/material.dart';
import 'package:resources/resources.dart';
import 'package:shared/shared.dart';

enum MealType {
  breakfast(0),
  lunch(1),
  snack(2),
  dinner(3),
  unknown(-1);

  const MealType(this.serverValue);
  final int serverValue;

  static const defaultValue = unknown;
}


enum InitialAppRoute {
  mealMenu,
}

enum Gender {
  male(ServerRequestResponseConstants.male),
  female(ServerRequestResponseConstants.female),
  other(ServerRequestResponseConstants.other),
  unknown(ServerRequestResponseConstants.unknown);

  const Gender(this.serverValue);
  final int serverValue;

  static const defaultValue = unknown;
}

enum LanguageCode {
  en(
    localeCode: LocaleConstants.en,
    serverValue: ServerRequestResponseConstants.en,
  ),
  ja(
    localeCode: LocaleConstants.ja,
    serverValue: ServerRequestResponseConstants.ja,
  );

  const LanguageCode({
    required this.localeCode,
    required this.serverValue,
  });
  final String localeCode;
  final String serverValue;

  static const defaultValue = ja;
}

enum NotificationType {
  unknown,
  newPost,
  liked;

  static const defaultValue = unknown;
}
