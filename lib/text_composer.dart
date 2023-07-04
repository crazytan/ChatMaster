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
    return Expanded(
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: "Send a message",
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(context, _textController.text),
          ),
        ),
        onSubmitted: (text) {
          _handleSubmitted(context, text);
        },
        focusNode: widget.focusNode,
        maxLines: null,
      ),
    );
  }

  void _handleSubmitted(BuildContext context, String text) {
    _textController.clear();
    Provider.of<ChatModel>(context, listen: false).addMessageToActiveSession(text);
    FocusScope.of(context).requestFocus(widget.focusNode);
  }
}
