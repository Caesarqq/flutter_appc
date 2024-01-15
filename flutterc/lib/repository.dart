import 'dart:math';
import 'chat_data.dart';

class Repository {
  final Random _random = Random();
  final int _chatsCount = 50;
  int _lastLoadedIndex = 0;

  void resetIndex() {
    _lastLoadedIndex = 0;
  }

  Future<List<ChatData>> getChats() async {
    await Future.delayed(Duration(seconds: 1));

    List<ChatData> nextChats = [];
    for (int i = 0; i < 15; i++) {
      if (_lastLoadedIndex < _chatsCount) {
        int unreadMessages = _random.nextInt(10);
        int messageNumber = _random.nextInt(1000);
        String lastMessage = 'Last message $messageNumber';
        nextChats.add(
            ChatData('Chat ${_lastLoadedIndex}', lastMessage, unreadMessages));
        _lastLoadedIndex++;
      } else {
        break;
      }
    }

    return nextChats;
  }
}
