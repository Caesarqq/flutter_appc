import 'package:flutter/material.dart';
import 'chat_data.dart';
import 'repository.dart';
import 'chat_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Repository _repository = Repository();
  List<ChatData> _chats = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadChats();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadChats() async {
    var chats = await _repository.getChats();
    setState(() {
      _chats.addAll(chats);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadChats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            color: Color.fromARGB(255, 39, 38, 38),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 35),
                        child: IconButton(
                          icon: Icon(Icons.menu,
                              color: const Color.fromARGB(255, 255, 255, 255)),
                          onPressed: () {},
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 35),
                        child: Text(
                          'Telegram',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 35),
                    child: IconButton(
                      icon: Icon(Icons.search,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _chats.clear();
                  _repository.resetIndex();
                });
                await _loadChats();
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  final chat = _chats[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Image.asset('assets/images/earth.png'),
                    ),
                    title: Text(chat.name),
                    subtitle: Text(chat.lastMessage),
                    trailing: chat.unreadMessages > 0
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Text(
                              chat.unreadMessages.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          )
                        : null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(chat: chat),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () async {
          setState(() {
            _chats.clear();
            _repository.resetIndex();
          });
          await _loadChats();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
