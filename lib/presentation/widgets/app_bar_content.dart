import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';

class ContentAppBar extends StatelessWidget {
  const ContentAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
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
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.INITIAL, (Route<dynamic> route) => false);
              },
              icon: const Icon(Icons.logout_rounded)),
        )
      ],
    );
  }
}
