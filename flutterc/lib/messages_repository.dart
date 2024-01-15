import 'dart:math';
import 'message_data.dart';

class MessagesRepository {
  final Random _random = Random();
  final List<MessageData> _messages = [];

  MessageData generateRandomMessage() {
    return MessageData('Message ${_random.nextInt(50)}');
  }

  Future<List<MessageData>> getMessages() async {
    await Future.delayed(Duration(seconds: 1));

    for (int i = 0; i < 4; i++) {
      _messages.insert(0, generateRandomMessage());
    }

    return List.from(_messages);
  }

  void sendMessage(String content) {
    _messages.insert(0, MessageData(content, isMine: true));
  }

  void removeMessage(MessageData message) {
    _messages.remove(message);
  }
}
