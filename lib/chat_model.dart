import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'json_file_io.dart';

typedef Message = OpenAIChatCompletionChoiceMessageModel;

class Session {
  final String name;
  List<Message> messages = [];

  Session({required this.name});

  Session.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        messages = hasMessages(json) ? json['messages'].map<Message>((m) => Message.fromMap(m)).toList() : [];

  Map<String, dynamic> toJson() => {'name': name, 'messages': messages.map((m) => m.toMap()).toList()};

  Message latestMessageAt(int index) => messages[messages.length - index - 1];

  bool isLatestMessageAtUserRole(int index) => messages[messages.length - index - 1].role == OpenAIChatMessageRole.user;

  void addUserInput(String text) {
    messages.add(Message(role: OpenAIChatMessageRole.user, content: text));
  }

  void removeLatestMessageAt(int index) {
    messages.removeAt(messages.length - index - 1);
  }

  static bool hasMessages(Map<String, dynamic> json) {
    if (!json.containsKey('messages')) return false;
    dynamic msgs = json['messages'];

    if (msgs is! List) {
      return false;
    }

    return msgs.isNotEmpty;
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
      if (data.isNotEmpty) {
        _sessions = data['sessions'].map<Session>((s) => Session.fromJson(s)).toList();
        _activeSessionIndex = data['activeSessionIndex'];
      } else {
        _sessions = [
          Session(name: 'Session 1'),
          Session(name: 'Session 2'),
        ];
        _saveData();
      }
      notifyListeners();
    });
  }

  void _saveData() {
    final data = {
      'sessions': _sessions.map((session) => session.toJson()).toList(),
      'activeSessionIndex': _activeSessionIndex,
    };
    JsonFileIO.writeJsonFile(data);
  }

  void createNewSession() {
    _sessions.add(Session(name: 'Session ${_sessions.length + 1}'));
    _activeSessionIndex = _sessions.length - 1;
    _saveData();
    notifyListeners();
  }

  void setActiveSession(int index) {
    _activeSessionIndex = index;
    _saveData();
    notifyListeners();
  }

  Future<void> addMessageToActiveSession(String text) async {
    if (text.isEmpty) return;

    Session session = activeSession;
    session.addUserInput(text);
    _saveData();

    OpenAI.instance.chat.create(model: "gpt-3.5-turbo", messages: session.messages).then((completion) {
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
}
