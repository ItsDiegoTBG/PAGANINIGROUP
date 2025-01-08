import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SlideInfo {
  final String title;
  final String caption;
  final String imageUrl;

  SlideInfo(
      {required this.title, required this.caption, required this.imageUrl});
}

final slides = <SlideInfo>[
  SlideInfo(
      title: 'Paga sin complicaciones',
      caption:
          "Realiza tus pagos directamente y sin problemas utilizando códigos QR.",
      imageUrl: 'assets/image/tutorial/1.jpg'),
  SlideInfo(
      title: "Tu billetera, tu estilo",
      caption:
          "Administra tu billetera digital y personalízala a tu gusto de forma fácil.",
      imageUrl: 'assets/image/tutorial/2.jpg'),
  SlideInfo(
      title: 'Pagos a tu alcance',
      caption:
          "Utiliza diferentes métodos de pago y realiza transacciones en pocos pasos.",
      imageUrl: 'assets/image/tutorial/3.jpg'),
  SlideInfo(
      title: 'Rapido y Sencillo',
      caption:
          "Una app sencilla, rápida y diseñada para que ahorres tiempo al pagar.",
      imageUrl: 'assets/image/tutorial/4.jpg'),
];

class AppTutorialScreen extends StatelessWidget {
  static const String name = "app_tutorial_screen";
  const AppTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: _AppTutorialView(),
    );
  }
}

class _AppTutorialView extends StatefulWidget {
  const _AppTutorialView();

  @override
  State<_AppTutorialView> createState() => _AppTutorialViewState();
}

class _AppTutorialViewState extends State<_AppTutorialView> {
  late final PageController _pageController = PageController();

  bool endReached = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page ?? 0;
      if (!endReached && page >= (slides.length - 1.5)) {
        setState(() {
          endReached = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          children: slides
              .map((e) => _SlideView(
                  title: e.title, caption: e.caption, imageUrl: e.imageUrl))
              .toList(),
        ),
        Positioned(
          right: 10,
          top: 30,
          child: TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.INITIAL,
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                "Salir",
                style: TextStyle(color: AppColors.primaryColor,fontSize: 20),
              )),
        ),
        endReached
            ? Positioned(
                bottom: 30,
                right: 30,
                child: FadeInRight(
                  from: 15,
                  delay: const Duration(milliseconds: 500),
                  child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryColor),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.INITIAL,
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
                        child: Text("Vamos !!"),
                      )),
                ))
            : const SizedBox(),
        Positioned(
          bottom: 120,
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: slides.length,
              effect: ExpandingDotsEffect(
                activeDotColor: colors.primary,
                dotColor: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SlideView extends StatelessWidget {
  final String title;
  final String caption;
  final String imageUrl;
  const _SlideView({
    required this.title,
    required this.caption,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontSize: 26, fontWeight: FontWeight.bold);
    const  captionStyle = TextStyle(fontSize: 14);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imageUrl),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: titleStyle,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              textAlign: TextAlign.justify,
              caption,
              style: captionStyle,
            ),
          ],
        ),
      ),
    );
  }
}
