import 'package:flutter/foundation.dart';

enum SessionStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class SessionNotifier extends ChangeNotifier {
  SessionStatus _status = SessionStatus.unknown;

  SessionStatus get status => _status;

  bool get isAuthenticated => _status == SessionStatus.authenticated;

  void markAuthenticated() => _set(SessionStatus.authenticated);

  void markUnauthenticated() => _set(SessionStatus.unauthenticated);

  void _set(SessionStatus value) {
    if (_status == value) return;
    _status = value;
    notifyListeners(); 
  }
}