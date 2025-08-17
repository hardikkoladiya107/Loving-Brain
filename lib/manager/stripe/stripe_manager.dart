class StripeManager {
  StripeManager._internal();

  static final StripeManager _instance = StripeManager._internal();

  static StripeManager get instance => _instance;
}
