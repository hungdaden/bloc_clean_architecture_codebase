import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../base/bloc/base_bloc_state.dart';

part 'app_state.freezed.dart';

@freezed
class AppState extends BaseBlocState with _$AppState {
  const factory AppState({
    @Default(LanguageCode.ja) LanguageCode languageCode,
    @Default(false) bool isDarkTheme,
    @Default(Color(0xFF2E7D32)) Color accentColor,
  }) = _AppState;
}
