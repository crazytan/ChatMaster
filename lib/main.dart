import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_model.dart';

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
  MultiSessionChatScreen({super.key});

  final TextEditingController _textController = TextEditingController();
  final FocusNode _textInputFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatModel>(
      builder: (context, chatModel, _) => Scaffold(
        appBar: AppBar(title: Text(chatModel.activeSession.name)),
        body: Row(
          children: [
            SizedBox(
              width: 200.0,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: chatModel.sessions.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(chatModel.sessions[index].name),
                        onTap: () {
                          chatModel.setActiveSession(index);
                          FocusScope.of(context)
                              .requestFocus(_textInputFocusNode);
                        },
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      chatModel.createNewSession();
                      FocusScope.of(context).requestFocus(_textInputFocusNode);
                    },
                    child: const Icon(Icons.add),
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
                    itemBuilder: (_, index) => ListTile(
                      title: Text(chatModel
                          .activeSession
                          .messages[chatModel.activeSession.messages.length -
                              index -
                              1]
                          .text),
                    ),
                  ),
                ),
                const Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildTextComposer(context),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration:
                  const InputDecoration.collapsed(hintText: "Send a message"),
              onSubmitted: (text) {
                _handleSubmitted(context, text);
              },
              focusNode: _textInputFocusNode,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(context, _textController.text),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(BuildContext context, String text) {
    _textController.clear();
    Provider.of<ChatModel>(context, listen: false)
        .addMessageToActiveSession(text);
    FocusScope.of(context).requestFocus(_textInputFocusNode);
  }
}
