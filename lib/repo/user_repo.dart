class UserRepo {
  UserRepo._();

  static final UserRepo _instance = UserRepo._();

  factory UserRepo() {
    return _instance;
  }
}
