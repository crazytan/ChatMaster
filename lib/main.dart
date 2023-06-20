import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatMaster',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chat Master'),
    );
  }
}

class Session {
  final String name;
  List<String> messages;

  Session({required this.name, List<String>? messages})
      : messages = messages ?? [];
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Session> _sessions = [
    Session(name: 'Session 1'),
    Session(name: 'Session 2'),
  ];
  int _activeSessionIndex = 0;

  final TextEditingController _textController = TextEditingController();

  final FocusNode _textInputFocusNode = FocusNode();

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text.isNotEmpty) {
      setState(() {
        _sessions[_activeSessionIndex].messages.add(text);
      });
    }
    FocusScope.of(context).requestFocus(_textInputFocusNode);
  }

  void _createNewSession() {
    setState(() {
      _sessions.add(Session(name: 'Session ${_sessions.length + 1}'));
      _activeSessionIndex = _sessions.length - 1;
    });
    FocusScope.of(context).requestFocus(_textInputFocusNode);
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration.collapsed(hintText: " Prompt"),
                onSubmitted: _handleSubmitted,
                autofocus: true,
                focusNode: _textInputFocusNode,
              ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _handleSubmitted(_textController.text);
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeSession = _sessions[_activeSessionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(activeSession.name),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 200.0,
            child: Column(children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _sessions.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(_sessions[index].name),
                    onTap: () {
                      setState(() {
                        _activeSessionIndex = index;
                      });
                      FocusScope.of(context).requestFocus(_textInputFocusNode);
                    },
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: _createNewSession,
                child: const Icon(Icons.add),
              ),
            ]),
          ),
          const VerticalDivider(width: 1.0),
          Expanded(
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    reverse: true,
                    itemCount: activeSession.messages.length,
                    itemBuilder: (_, int index) => ListTile(
                      title: Text(activeSession
                          .messages[activeSession.messages.length - index - 1]),
                    ),
                  ),
                ),
                const Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildTextComposer(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
