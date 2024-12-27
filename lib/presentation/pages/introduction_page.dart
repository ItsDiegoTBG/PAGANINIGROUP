import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/pages/home_page.dart';
import 'package:paganini/presentation/pages/initial_page.dart';
import 'package:paganini/presentation/pages/register_page.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const InitialPage()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      "assets/image/paganini_icono_morado.png",
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(
        'assets/image/$assetName',
        width: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 5000,
      infiniteAutoScroll: true,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage('paganini_logo_horizontal_morado_lila.png', 150),
          ),
        ),
      ),
      globalFooter: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: SizedBox(
          width: 250,
          height: 70,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text(
              '«¡Vamos ahora mismo!»,',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            onPressed: () async {
              _onIntroEnd(context);
            },
          ),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Paga sin complicaciones",
          bodyWidget: const Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                "Realiza tus pagos directamente y sin problemas utilizando códigos QR.",
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(
                height: 30,
              ),
              Icon(
                Icons.qr_code_rounded,
                size: 115,
                color: AppColors.primaryColor,
              ),
            ],
          ),
          image: _buildImage('diferent_payments.jpg', 250),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Tu billetera, tu estilo",
          bodyWidget: const Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                "Administra tu billetera digital y personalízala a tu gusto de forma fácil.",
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(
                height: 25,
              ),
              Icon(
                Icons.credit_score_rounded,
                size: 120,
                color: AppColors.primaryColor,
              ),
            ],
          ),
          image: _buildImage('pago_movil1.jpg', 250),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Pagos a tu alcance",
          body:
              "Utiliza diferentes métodos de pago y realiza transacciones en pocos pasos.",
          image: _buildFullscreenImage(),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "Rapido y Sencillo",
          bodyWidget: const Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                "Una app sencilla, rápida y diseñada para que ahorres tiempo al pagar.",
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(
                height: 10,
              ),
              Icon(
                Icons.phone_android_rounded,
                size: 115,
                color: AppColors.primaryColor,
              ),
            ],
          ),
          image: _buildImage('pago_movil2.jpg', 250),
          decoration: pageDecoration.copyWith(
            bodyFlex: 6,
            imageFlex: 6,
            safeArea: 80,
          ),
          /*footer: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ElevatedButton(
              onPressed: () {
                _onIntroEnd(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Iniciemos',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),*/
        ),
      ],
      onDone: () => _onIntroEnd(
          context), //cambio de esto para que no vuelva a parecer la pagina de introduction screen
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Saltar',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Ir',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: AppColors.secondaryColor,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
