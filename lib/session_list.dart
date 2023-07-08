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
    );
  }
}
