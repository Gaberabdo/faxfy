import 'dart:io';
import 'package:windows_notification/windows_notification.dart';
import 'package:windows_notification/notification_message.dart';

final WindowsNotification _winNotifyPlugin = WindowsNotification(
  applicationId: "Faxify",
);

/// Initialize Windows Notification plugin (should be called once)
void initWindowsNotification() {
  _winNotifyPlugin.initNotificationCallBack((details) {});
}

/// Sends a Windows notification with optional image
Future<void> sendWindowsNotification({
  required String title,
  required String body,
}) async {
  final message = NotificationMessage.fromPluginTemplate(
    title,
    title,
    body,
    group: "Faxify",
  );

  _winNotifyPlugin.showNotificationPluginTemplate(message);
}
