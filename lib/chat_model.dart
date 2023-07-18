import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';

import 'json_file_io.dart';

typedef Message = OpenAIChatCompletionChoiceMessageModel;

class Session {
  final String name;
  List<Message> messages = [
    const Message(
      role: OpenAIChatMessageRole.system,
      content: 'You are a helpful assistant. You can help me by answering my questions. You can also ask me questions.',
    )
  ];

  Session({required this.name});

  Session.fromMap(Map<String, dynamic> json)
      : name = json['name'],
        messages = hasMessages(json) ? json['messages'].map<Message>((m) => Message.fromMap(m)).toList() : [];

  static bool hasMessages(Map<String, dynamic> json) {
    if (!json.containsKey('messages')) return false;
    dynamic messages = json['messages'];

    if (messages is! List) {
      return false;
    }

    return messages.isNotEmpty;
  }

  Map<String, dynamic> toMap() => {'name': name, 'messages': messages.map((m) => m.toMap()).toList()};

  Message latestMessageAt(int index) => messages[messages.length - index - 1];

  bool isLatestMessageAtUserRole(int index) => messages[messages.length - index - 1].role == OpenAIChatMessageRole.user;

  void addUserInput(String text) {
    messages.add(Message(role: OpenAIChatMessageRole.user, content: text));
  }

  void removeLatestMessageAt(int index) {
    messages.removeAt(messages.length - index - 1);
  }
}

class ChatModel extends ChangeNotifier {
  List<Session> _sessions = [Session(name: 'Session 1')];
  int _activeSessionIndex = 0;

  ChatModel() {
    _loadData();
  }

  List<Session> get sessions => _sessions;

  Session get activeSession => _sessions[_activeSessionIndex];

  int get activeSessionIndex => _activeSessionIndex;

  void _loadData() {
    JsonFileIO.readJsonFile().then((data) {
      if (data.containsKey('sessions')) {
        _sessions = data['sessions'].map<Session>((s) => Session.fromMap(s)).toList();
      }
      if (data.containsKey('activeSessionIndex')) _activeSessionIndex = data['activeSessionIndex'];
      if (data.containsKey('modelSelection')) _modelSelection = data['modelSelection'];
      notifyListeners();
    });
  }

  void _saveData() {
    final data = {
      'sessions': _sessions.map((session) => session.toMap()).toList(),
      'activeSessionIndex': _activeSessionIndex,
      'modelSelection': modelSelection,
    };
    JsonFileIO.writeJsonFile(data);
  }

  void createNewSession() {
    _sessions.add(Session(name: 'Session ${_sessions.length + 1}'));
    _activeSessionIndex = _sessions.length - 1;
    _inSettings = false;
    _saveData();
    notifyListeners();
  }

  void deleteSession(int index) {
    _sessions.removeAt(index);
    if (_activeSessionIndex >= _sessions.length) _activeSessionIndex = _sessions.length - 1;
    _saveData();
    notifyListeners();
  }

  void setActiveSession(int index) {
    _activeSessionIndex = index;
    _inSettings = false;
    _saveData();
    notifyListeners();
  }

  Future<void> addMessageToActiveSession(String text) async {
    if (text.isEmpty) return;

    Session session = activeSession;
    session.addUserInput(text);
    _saveData();

    OpenAI.instance.chat.create(model: modelSelection, messages: session.messages).then((completion) {
      if (!completion.haveChoices) return;

      session.messages.add(completion.choices.first.message);
      _saveData();
      notifyListeners();
    }).catchError((error) {
      debugPrint(error);
    });
    notifyListeners();
  }

  void deleteMessageFromActiveSession(int index) {
    activeSession.removeLatestMessageAt(index);
    _saveData();
    notifyListeners();
  }

  bool _inSettings = false;

  bool get inSettings => _inSettings;

  void switchToSettings() {
    _inSettings = true;
    notifyListeners();
  }

  void switchToChat() {
    _inSettings = false;
    notifyListeners();
  }

  String _modelSelection = models[0];

  String get modelSelection => _modelSelection;

  static final List<String> models = ['gpt-3.5-turbo', 'gpt-4', 'gpt-4-32k'];

  void setModel(String newModel) {
    if (!models.contains(newModel)) return;
    _modelSelection = newModel;
    notifyListeners();
  }
}
