import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:gap/gap.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/local/notification_service.dart';
import 'package:paganini/domain/entity/user_entity.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
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
    final userProvider = context.watch<UserProvider>();
    final notificationService = Provider.of<NotificationService>(context);
    final UserEntity userEntity = userProvider.currentUser!;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 285,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 235,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.secondaryColor,
                      //  border: Border.all(color: AppColors.primaryColor,width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Gap(60),
                        Center(
                            child: Text(userEntity.firstname,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                        const Gap(10),
                        const Text('FCW-587462',
                            style: TextStyle(color: Colors.black)),
                        const Gap(25),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _ContainerIcon(
                                  iconData: Icons.dark_mode,
                                  color: const Color(0xFFe2a935),
                                  onTap: () {
                                    themeProvider.toggleTheme();
                                  }),
                              _ContainerIcon(
                                  iconData: Icons.credit_card_off_outlined,
                                  color: const Color(0xFF2290b8),
                                  onTap: () {
                                    Navigator.pushNamed(context,Routes.CARDDELETEPAGE);
                                  }),
                              _ContainerIcon(
                                  iconData: Icons.settings,
                                  color: const Color(0xFF6bcde8),
                                  onTap: () {
                                    Navigator.pushNamed(context,Routes.SETTINGSPAGE);
                                  }),
                              _ContainerIcon(
                                  iconData: Icons.logout,
                                  color: const Color(0xFF6b41dc),
                                  onTap: () {
                                    userProvider.signOut();
                                    notificationService.showNotification(
                                        "Sesion Cerrada",
                                        "Haz cerrado sesion de manera exitosa");
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        Routes.INITIAL,
                                        (Route<dynamic> route) => false);
                                  }),
                            ]),
                        const Gap(23)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  right: 30,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    child: Transform.scale(
                      scale: 0.55,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                            "assets/image/paganini_icono_blanco.png"),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            const ContainerSettings(
              text: "Informacion",
              iconData: Icons.info_outline,
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
              text: "Soporte",
              iconData: Icons.support_agent_outlined,
            ),
            const SizedBox(height: 10,),
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
          ],
        ),
      ),
    );
  }
}

class _ContainerIcon extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final GestureTapCallback onTap;
  const _ContainerIcon({
    required this.iconData,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(13),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: GestureDetector(onTap: onTap, child: Icon(iconData, color: color)),
    );
  }
}



/*   ContainerSettings(
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
             ContainerSettings(
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.LOGIN, (Route<dynamic> route) => false);
                notificationService.showNotification("Sesion Cerrada", "Haz cerrado sesion de manera exitosa");
                await userProvider.signOut();
              },
              withoutIconArrowGo: true,
              text: "Cerrar Sesión",
              iconData: Icons.logout_outlined,
            ), */