import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/pages/cards/wallet_page.dart';
import 'package:paganini/presentation/pages/home_page.dart';
import 'package:paganini/presentation/pages/qr_pages.dart';
import 'package:paganini/presentation/pages/setting_page.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';

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
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const ContentAppBar(),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            child: CurvedNavigationBar(
                backgroundColor: Colors.transparent,
                color: AppColors.primaryColor,
                buttonBackgroundColor: AppColors.primaryColor,
                index: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                items: const [
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
                  Icon(Icons.settings, size: 30),
                ])));
  }
}
