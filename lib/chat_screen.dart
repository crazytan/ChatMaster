import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_model.dart';
import 'text_composer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required FocusNode textInputFocusNode,
  }) : _textInputFocusNode = textInputFocusNode;

  final FocusNode _textInputFocusNode;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
        child: Consumer<ChatModel>(
          builder: (context, chatModel, _) => ListView.builder(
            padding: const EdgeInsets.all(1.0),
            reverse: true,
            itemCount: chatModel.activeSession.messages.length,
            itemBuilder: (_, index) {
              bool isUser = chatModel.activeSession.isLatestMessageAtUserRole(index);
              Widget deleteButton = IconButton(
                  onPressed: () => chatModel.deleteMessageFromActiveSession(index), icon: const Icon(Icons.delete));
              Widget message = Flexible(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SelectableText(
                      chatModel.activeSession.latestMessageAt(index).content,
                      style: Theme.of(context).textTheme.bodyLarge,
                      selectionControls: MaterialTextSelectionControls(),
                      maxLines: null,
                    ),
                  ),
                ),
              );
              return Container(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: isUser ? [deleteButton, message] : [message, deleteButton],
                ),
              );
            },
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
    ]);
  }
}
