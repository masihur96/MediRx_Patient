import 'package:flutter/foundation.dart';
import '../../domain/repositories/ai_assistant_repository.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AiAssistantViewModel extends ChangeNotifier {
  final AiAssistantRepository _repository;

  AiAssistantViewModel(this._repository);

  bool _isSending = false;
  bool get isSending => _isSending;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Hello! I am your AI Health Assistant. How can I help you today?',
      isUser: false,
    ),
  ];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(text: text.trim(), isUser: true));
    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.chat(text.trim());

    _isSending = false;
    if (result.isSuccess && result.data != null) {
      _messages.add(ChatMessage(text: result.data!, isUser: false));
    } else {
      _errorMessage = result.error ?? 'Something went wrong';
      _messages.add(ChatMessage(
        text:
            'I\'m sorry, I couldn\'t process your request right now. Please try again.',
        isUser: false,
      ));
    }

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
