// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_ai_toolkit/src/providers/interface/chat_message.dart';

import '../../llm_exception.dart';
import '../interface/attachments.dart';
import '../interface/llm_provider.dart';

/// A simple LLM provider that echoes the input prompt and attachment
/// information.
///
/// This provider is primarily used for testing and debugging purposes.
class EchoProvider extends LlmProvider {
  /// Creates an [EchoProvider] instance with an optional chat history.
  ///
  /// The [history] parameter is an optional iterable of [ChatMessage] objects
  /// representing the chat history. If provided, it will be converted to a list
  /// and stored internally. If not provided, an empty list will be used.
  EchoProvider({Iterable<ChatMessage>? history})
      : _history = List<ChatMessage>.from(history ?? []);

  final List<ChatMessage> _history;

  @override
  Future<List<double>> getDocumentEmbedding(String document) {
    throw UnimplementedError('EchoProvider.getDocumentEmbedding');
  }

  @override
  Future<List<double>> getQueryEmbedding(String query) {
    throw UnimplementedError('EchoProvider.getQueryEmbedding');
  }

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) =>
      _generateStream(prompt, attachments: attachments);

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    _history.addAll([userMessage, llmMessage]);
    final chunks = _generateStream(prompt, attachments: attachments);
    await for (final chunk in chunks) {
      llmMessage.append(chunk);
      yield chunk;
    }
  }

  Stream<String> _generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    await Future.delayed(const Duration(milliseconds: 1000));
    yield '# Echo\n';

    switch (prompt) {
      case 'CANCEL':
        throw const LlmCancelException();
      case 'FAIL':
        throw const LlmFailureException('User requested failure');
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    yield prompt;

    yield '\n\n# Attachments\n${attachments.map(_stringFrom)}';
  }

  String _stringFrom(Attachment attachment) => attachment.toString();

  @override
  Iterable<ChatMessage> get history => _history;

  @override
  ({ChatMessage? llmMessage, ChatMessage? userMessage}) getLastMessagePair({
    bool pop = false,
  }) {
    final llmIndex = _history.lastIndexWhere((m) => m.origin.isLlm);
    final userIndex = _history.lastIndexWhere((m) => m.origin.isUser);
    assert(llmIndex == -1 || llmIndex == _history.length - 1);
    assert(userIndex == -1 || userIndex == _history.length - 2);
    final llm = llmIndex == -1 ? null : _history[llmIndex];
    final user = userIndex == -1 ? null : _history[userIndex];
    if (pop) _history.removeRange(userIndex, _history.length);
    return (llmMessage: llm, userMessage: user);
  }
}
