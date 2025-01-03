import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/widgets/container_settings.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool dartThemeSelected = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Configuraciones',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
           
            ContainerSettings(
              text: "Tema Oscuro",
              iconData: Icons.dark_mode_outlined,
              needSwitch: true,
              darkThemeSelected: dartThemeSelected,
              onSwitchChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                setState(() {
                  dartThemeSelected = value;
                });
              },
            ),
            const SizedBox(height: 10),
            const ContainerSettings(
              text: "Notificaciones",
              iconData: Icons.notifications_none_outlined,
            ),
            const SizedBox(height: 10),
            const ContainerSettings(
              text: "Privacidad",
              iconData: Icons.privacy_tip_outlined,
            ),
            const SizedBox(height: 10),
            const ContainerSettings(
              text: "Nosotros",
              iconData: Icons.people_outline,
            ),
            const SizedBox(height: 10),
            const ContainerSettings(
              text: "Cerrar Sesión",
              iconData: Icons.logout_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

