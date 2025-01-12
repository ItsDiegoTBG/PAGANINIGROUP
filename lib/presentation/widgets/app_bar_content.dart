import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ContentAppBar extends StatelessWidget {
  const ContentAppBar({
    super.key,
  });

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        themeProvider.isDarkMode
            ? Padding(
                padding: const EdgeInsets.only(left: 1),
                child: SizedBox(
                    width: 220,
                    height: 100,
                    child: Image.asset(
                        "assets/image/paganini_logo_horizontal_blanco.png")),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 1),
                child: SizedBox(
                    width: 220,
                    height: 100,
                    child: Image.asset(
                        "assets/image/paganini_logo_horizontal_morado_lila.png")),
              ),
        Padding(
          padding: const EdgeInsets.only(right: 1),
          child: IconButton(
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.LOGIN, (Route<dynamic> route) => false);
                await userProvider.signOut();
              },
              icon: const Icon(Icons.logout_rounded)),
        )
      ],
    );
  }
}
