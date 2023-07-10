import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_model.dart';

class SessionList extends StatelessWidget {
  const SessionList({
    super.key,
    required FocusNode textInputFocusNode,
  }) : _textInputFocusNode = textInputFocusNode;

  final FocusNode _textInputFocusNode;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatModel>(builder: (context, chatModel, _) => sizedBox(context, chatModel));
  }

  Widget sizedBox(BuildContext context, ChatModel chatModel) {
    return SizedBox(
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
                    selected: !chatModel.inSettings && chatModel.activeSessionIndex == index,
                    onTap: () {
                      chatModel.setActiveSession(index);
                      FocusScope.of(context).requestFocus(_textInputFocusNode);
                    },
                    contentPadding: const EdgeInsets.only(left: 10, right: 5, top: 0, bottom: 0),
                    // visualDensity: VisualDensity(horizontal: -4),
                    trailing: IconButton(
                      onPressed: () => chatModel.deleteSession(index),
                      icon: const Icon(Icons.delete),
                    )),
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                chatModel.createNewSession();
                FocusScope.of(context).requestFocus(_textInputFocusNode);
              },
              label: const Text('New Chat'),
              icon: const Icon(Icons.add),
              style: TextButtonTheme.of(context).style,
            ),
          ),
          SizedBox(
            height: 50.0,
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                chatModel.switchToSettings();
              },
              label: const Text('Settings'),
              icon: const Icon(Icons.settings),
              style: TextButtonTheme.of(context).style,
            ),
          ),
        ],
      ),
    );
  }
}
