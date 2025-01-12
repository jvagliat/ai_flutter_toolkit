// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'fat_colors.dart';
import 'fat_text_styles.dart';
import 'style_helpers.dart' as sh;

/// Style for the input text box.
@immutable
class ChatInputStyle {
  /// Creates an InputBoxStyle.
  const ChatInputStyle({
    this.textStyle,
    this.hintStyle,
    this.hintText,
    this.backgroundColor,
    this.decoration,
  });

  /// Merges the provided styles with the default styles.
  factory ChatInputStyle.resolve(
    ChatInputStyle? style, {
    ChatInputStyle? defaultStyle,
  }) {
    defaultStyle ??= ChatInputStyle.defaultStyle();
    return ChatInputStyle(
      textStyle: style?.textStyle ?? defaultStyle.textStyle,
      hintStyle: style?.hintStyle ?? defaultStyle.hintStyle,
      hintText: style?.hintText ?? defaultStyle.hintText,
      backgroundColor: style?.backgroundColor ?? defaultStyle.backgroundColor,
      decoration: style?.decoration ?? defaultStyle.decoration,
    );
  }

  /// Provides a default dark style.
  factory ChatInputStyle.darkStyle() {
    final style = ChatInputStyle.lightStyle();
    return ChatInputStyle(
      decoration: sh.invertDecoration(style.decoration),
      textStyle: sh.invertTextStyle(style.textStyle),
      // inversion doesn't look great here
      // hintStyle: sh.invertTextStyle(style.hintStyle),
      hintStyle: FatTextStyles.body2.copyWith(
        color: FatColors.greyBackground,
      ),
      hintText: style.hintText,
      backgroundColor: sh.invertColor(style.backgroundColor),
    );
  }

  /// Provides a default style.
  factory ChatInputStyle.defaultStyle() => ChatInputStyle.lightStyle();

  /// Provides a default light style.
  factory ChatInputStyle.lightStyle() => ChatInputStyle(
        textStyle: FatTextStyles.body2,
        hintStyle: FatTextStyles.body2.copyWith(color: FatColors.hintText),
        hintText: 'Ask me anything...',
        backgroundColor: FatColors.containerBackground,
        decoration: BoxDecoration(
          color: FatColors.containerBackground,
          border: Border.all(width: 1, color: FatColors.outline),
          borderRadius: BorderRadius.circular(24),
        ),
      );

  /// The text style for the input text box.
  final TextStyle? textStyle;

  /// The hint text style for the input text box.
  final TextStyle? hintStyle;

  /// The hint text for the input text box.
  final String? hintText;

  /// The background color of the input box.
  final Color? backgroundColor;

  /// The decoration of the input box.
  final Decoration? decoration;
}
