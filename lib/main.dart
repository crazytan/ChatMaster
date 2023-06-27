import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_model.dart';
import 'text_composer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatMaster',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (context) => ChatModel(),
        child: MultiSessionChatScreen(),
      ),
    );
  }
}

class MultiSessionChatScreen extends StatelessWidget {
  final FocusNode _textInputFocusNode = FocusNode();

  MultiSessionChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatModel>(
      builder: (context, chatModel, _) => Scaffold(
        //appBar: AppBar(title: Text(chatModel.activeSession.name)),
        body: Row(
          children: [
            SizedBox(
              width: 200.0,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: chatModel.sessions.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          title: Text(
                            chatModel.sessions[index].name,
                          ),
                          selected: chatModel.activeSessionIndex == index,
                          onTap: () {
                            chatModel.setActiveSession(index);
                            FocusScope.of(context).requestFocus(_textInputFocusNode);
                          },
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      chatModel.createNewSession();
                      FocusScope.of(context).requestFocus(_textInputFocusNode);
                    },
                    label: const Text('New Chat'),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1.0),
            Expanded(
              child: Column(children: [
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    reverse: true,
                    itemCount: chatModel.activeSession.messages.length,
                    itemBuilder: (_, index) => Card(
                      child: ListTile(
                        title: Text(
                            chatModel.activeSession.messages[chatModel.activeSession.messages.length - index - 1].text),
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: TextComposer(
                    focusNode: _textInputFocusNode,
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
