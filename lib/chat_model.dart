import 'package:flutter/material.dart';

class Message {
  final String text;

  Message({required this.text});
}

class Session {
  final String name;
  List<Message> messages = [];

  Session({required this.name});
}

class ChatModel extends ChangeNotifier {
  final List<Session> _sessions = [
    Session(name: 'Session 1'),
    Session(name: 'Session 2'),
  ];
  int _activeSessionIndex = 0;

  List<Session> get sessions => _sessions;

  Session get activeSession => _sessions[_activeSessionIndex];

  void createNewSession() {
    _sessions.add(Session(name: 'Session ${_sessions.length + 1}'));
    _activeSessionIndex = _sessions.length - 1;
    notifyListeners();
  }

  void setActiveSession(int index) {
    _activeSessionIndex = index;
    notifyListeners();
  }

  void addMessageToActiveSession(String text) {
    if (text.isNotEmpty) {
      _sessions[_activeSessionIndex].messages.add(Message(text: text));
      notifyListeners();
    }
  }
}
