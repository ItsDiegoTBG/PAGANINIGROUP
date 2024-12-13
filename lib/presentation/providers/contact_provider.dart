import 'package:flutter/material.dart';

import 'package:paganini/presentation/widgets/contact_user.dart';

class ContactProvider with ChangeNotifier {
  ContactUserWidget? _contactTransfered;
  ContactUserWidget? get contactTransfered => _contactTransfered;

  Future<void> setContactTransfered(ContactUserWidget contact) async {
    _contactTransfered = contact;
    notifyListeners();
  }

  void resetContact() {
    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
    return; // Evita notificaciones si el árbol está bloqueado
  }
    _contactTransfered = null;
    notifyListeners();
  }
}
