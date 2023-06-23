import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_model.dart';

class TextComposer extends StatefulWidget {
  final FocusNode focusNode;

  const TextComposer({super.key, required this.focusNode});

  @override
  State createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(hintText: "Send a message"),
              onSubmitted: (text) {
                _handleSubmitted(context, text);
              },
              focusNode: widget.focusNode,
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
    Provider.of<ChatModel>(context, listen: false).addMessageToActiveSession(text);
    FocusScope.of(context).requestFocus(widget.focusNode);
  }
}
