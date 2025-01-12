import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestNotificationPermission {
  static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        debugPrint("Permiso concedido para notificaciones");
      } else {
        debugPrint("Permiso denegado para notificaciones");
      }
    }
  }
}
