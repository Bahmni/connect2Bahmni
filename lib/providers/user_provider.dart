import '../../domain/models/user.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
  void updateUser(User user) {
    _user = user;
  }
}