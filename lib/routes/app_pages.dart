
import 'package:get/get.dart';
import 'package:paganini/presentation/pages/home_page.dart';
import 'package:paganini/presentation/pages/initial_page.dart';
import 'package:paganini/presentation/pages/login_page.dart';
import 'package:paganini/presentation/pages/qr_pages.dart';
import 'package:paganini/presentation/pages/wallet_page.dart';
part './app_routes.dart';
abstract class AppPages {

  static final pages = [
    GetPage(name: Routes.HOME, page: () => const HomePage(),transition: Transition.native),
    GetPage(name: Routes.INITIAL, page: () => const InitialPage(),transition: Transition.native),
    GetPage(name: Routes.LOGIN, page: () => const LoginRegisterScreen(),transition: Transition.native),
    GetPage(name: Routes.QRPAGE, page: () => const QrPage(),transition: Transition.native),
    GetPage(name: Routes.WALLETPAGE, page: () => const WalletPage(),transition: Transition.native),
    
  ];
}