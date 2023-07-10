import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_model.dart';
import 'chat_screen.dart';
import 'env.dart';
import 'session_list.dart';
import 'settings_screen.dart';

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
    return Scaffold(
      body: Row(
        children: [
          SessionList(textInputFocusNode: _textInputFocusNode),
          const VerticalDivider(width: 1.0),
          Expanded(
            child: Selector<ChatModel, bool>(
                selector: (_, chatModel) => chatModel.inSettings,
                builder: (_, inSettings, __) =>
                    inSettings ? const SettingsScreen() : ChatScreen(textInputFocusNode: _textInputFocusNode)),
          ),
        ],
      ),
    );
  }
}
