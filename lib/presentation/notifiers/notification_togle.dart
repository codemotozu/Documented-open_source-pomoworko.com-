import 'dart:html' as html;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/data_sources/hive_services.dart';

class NotificationToggle extends StateNotifier<bool> {
  NotificationToggle() : super(false) {
    initState();
  }

  Future<void> initState() async {
    state = await HiveServices.retrieveNotificationSwitchState();
  }

  void toggle() async {
    bool oldState = state;
    state = !state;

    if (html.Notification.supported) {
      if (state == true) {
        if (html.Notification.permission != "granted") {
          await html.Notification.requestPermission().then((permission) {
            if (permission != "granted") {
              state = oldState;
            }

          });
        }
      } else {
        // When turning notifications OFF
        // You can't revoke browser permissions. You can only ensure that you don't send notifications.

        // You can, however, show a prompt or guide on how the user can manually disable it in browser settings.
      }
      await HiveServices.saveNotificationSwitchState(state);
    }
  }
}