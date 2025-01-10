import 'package:animate_do/animate_do.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/local/notification_service.dart';
import 'package:paganini/presentation/pages/cards/wallet_page.dart';
import 'package:paganini/presentation/pages/home/home_page.dart';
import 'package:paganini/presentation/pages/page_qr/qr_pages.dart';
import 'package:paganini/presentation/pages/setting/setting_page.dart';

import 'package:paganini/presentation/providers/theme_provider.dart';
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
    final notificationService = Provider.of<NotificationService>(context);
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const ContentAppBar(),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(
                  color:
                      themeProvider.isDarkMode ? Colors.black : Colors.white),
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
                  final icon = itemsIcons[index];
                  SpinPerfect(
                    infinite: true,
                    duration: const Duration(seconds: 10),
                    child: icon,
                  );
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                items: List.generate(itemsIcons.length, (index) {
                  return _selectedIndex == index
                      ? Swing(
                          infinite: true,
                          duration: const Duration(seconds: 15),
                          child: itemsIcons[index],
                        )
                      : itemsIcons[index];
                }))));
  }
}
