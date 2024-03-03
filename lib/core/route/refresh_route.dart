import 'dart:async';

import 'package:flutter/foundation.dart';

class GoRouteRefreshStream extends ChangeNotifier {
  GoRouteRefreshStream(Stream<dynamic> steam) {
    notifyListeners();

    _subscription = steam.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
