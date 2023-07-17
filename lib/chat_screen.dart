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
      Container(
        padding: const EdgeInsets.all(15.0),
        child: Selector<ChatModel, String>(
          selector: (_, chatModel) => chatModel.activeSession.name,
          builder: (context, settingName, _) => Text(
            settingName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
      Expanded(
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
              double edgeInset = MediaQuery.of(context).size.width * 0.2;
              return Container(
                padding: isUser
                    ? EdgeInsets.only(left: edgeInset, right: 2.0, top: 2.0, bottom: 2.0)
                    : EdgeInsets.only(left: 2.0, right: edgeInset, top: 2.0, bottom: 2.0),
                child: Row(
                  mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: isUser ? [deleteButton, message] : [message, deleteButton],
                ),
              );
            },
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor),
        padding: const EdgeInsets.all(6.0),
        child: TextComposer(
          focusNode: _textInputFocusNode,
        ),
      ),
    ]);
  }
}
