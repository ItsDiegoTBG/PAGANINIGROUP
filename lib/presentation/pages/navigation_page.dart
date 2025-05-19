import 'package:animate_do/animate_do.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/local/notification_service.dart';
import 'package:paganini/presentation/pages/cards/wallet_page.dart';
import 'package:paganini/presentation/pages/home/home_page.dart';
import 'package:paganini/presentation/pages/notification_screen.dart';
import 'package:paganini/presentation/pages/page_qr/qr_pages.dart';
import 'package:paganini/presentation/pages/setting/setting_page.dart';

import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:provider/provider.dart';

class NavigationPage extends StatefulWidget {
  final int initialIndex;
  const NavigationPage({super.key, this.initialIndex = 0});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const QrPage(),
    const WalletPage(),
    const SettingPage()
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void goToIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    //final notificationService = Provider.of<NotificationService>(context);
    const itemsIcons = [
      Icon(
        Icons.home,
        size: 30,
      ),
      Icon(
        Icons.qr_code,
        size: 30,
      ),
      Icon(
        Icons.wallet,
        size: 30,
      ),
      Icon(Icons.person_pin_circle_sharp, size: 30),
    ];
    return Scaffold(
        appBar: ImprovedAppBar(
          selectedIndex: _selectedIndex,
          userName: userProvider.currentUser?.firstname ?? '',
          notificationCount:
              5, // O la variable que contenga el número de notificaciones
          onBackPressed: () {
            Navigator.of(context).pop();
          },
          onNotificationPressed: () {
            // Navegar a la pantalla de notificaciones
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationScreen()),
            );
          },
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(
              color: themeProvider.isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          child: CurvedNavigationBar(
            animationDuration: const Duration(milliseconds: 500),
            backgroundColor: Colors.transparent,
            color: themeProvider.isDarkMode
                ? Colors.white
                : AppColors.primaryColor,
            buttonBackgroundColor: themeProvider.isDarkMode
                ? Colors.white
                : AppColors.primaryColor,
            index: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: List.generate(itemsIcons.length, (index) {
              return itemsIcons[index];
            }),
          ),
        ));
  }
}

class ImprovedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final String userName;
  final int notificationCount;
  final Function() onBackPressed;
  final Function() onNotificationPressed;

  const ImprovedAppBar({
    Key? key,
    required this.selectedIndex,
    required this.userName,
    this.notificationCount = 0,
    required this.onBackPressed,
    required this.onNotificationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      automaticallyImplyLeading: false,
      titleSpacing: 0, // Eliminar espacio predeterminado para tener más control

      // Leading con más padding
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: selectedIndex == 0
            ? CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(
                  height: 20,
                  width: 20,
                  "assets/image/paganini_icono_morado.png",
                  fit: BoxFit.contain,
                ),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back,color: Colors.white,),
                onPressed: onBackPressed,
              ),
      ),

      // Título alineado a la izquierda con formato especial
      title: Row(
        children: [
          const SizedBox(width: 8), // Espacio entre avatar y texto
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 18),
              children: [
                const TextSpan(text: "Bienvenido, "),
                TextSpan(
                  text: userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),

      // Acciones con padding adicional
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: onNotificationPressed,
            child: Badge(
              label: Text(
                notificationCount > 99 ? "99+" : "$notificationCount",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              backgroundColor: Colors.red,
              isLabelVisible: notificationCount > 0,
              child: const Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
