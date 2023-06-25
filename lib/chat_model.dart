import 'package:flutter/material.dart';
import 'json_file_io.dart';

class Message {
  final String text;

  Message({required this.text});

  Message.fromJson(Map<String, dynamic> json) : text = json['text'];

  Map<String, dynamic> toJson() => {'text': text};
}

class Session {
  final String name;
  List<Message> messages = [];

  Session({required this.name});

  Session.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        messages = hasMessages(json) ? json['messages'].map<Message>((m) => Message.fromJson(m)).toList() : [];

  Map<String, dynamic> toJson() => {'name': name, 'messages': messages.map((m) => m.toJson()).toList()};

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
  List<Session> _sessions = [Session(name: 'Session 0')];
  int _activeSessionIndex = 0;

  ChatModel() {
    _loadData();
  }

  List<Session> get sessions => _sessions;

  Session get activeSession => _sessions[_activeSessionIndex];

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

  void addMessageToActiveSession(String text) {
    if (text.isNotEmpty) {
      _sessions[_activeSessionIndex].messages.add(Message(text: text));
      _saveData();
      notifyListeners();
    }
  }
}
