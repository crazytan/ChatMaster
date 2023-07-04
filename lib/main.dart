import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_model.dart';
import 'env.dart';
import 'text_composer.dart';

void main() {
  OpenAI.apiKey = Env.apiKey;
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
        body: Row(
          children: [
            SizedBox(
              width: 160.0,
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
                    padding: const EdgeInsets.all(1.0),
                    reverse: true,
                    itemCount: chatModel.activeSession.messages.length,
                    itemBuilder: (_, index) => Container(
                      padding: const EdgeInsets.all(4.0),
                      child: Align(
                        alignment: chatModel.activeSession.isLatestMessageAtUserRole(index)
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(chatModel.activeSession.latestMessageAt(index).content,
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        ),
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
