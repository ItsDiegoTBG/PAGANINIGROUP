import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
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
      imageUrl: 'assets/image/tutorial/7.png'),
  SlideInfo(
      title: "Tu billetera, tu estilo",
      caption:
          "Administra tu billetera digital y personalízala a tu gusto de forma fácil.",
      imageUrl: 'assets/image/tutorial/4.png'),
  SlideInfo(
      title: 'Pagos a tu alcance',
      caption:
          "Utiliza diferentes métodos de pago y realiza transacciones en pocos pasos.",
      imageUrl: 'assets/image/tutorial/5.png'),
  SlideInfo(
      title: 'Rapido y Sencillo',
      caption:
          "Una app sencilla, rápida y diseñada para que ahorres tiempo al pagar.",
      imageUrl: 'assets/image/tutorial/1.png'),
];

class Onboarding2Screen extends StatefulWidget {
  static const String name = "onboarding_screen";
  
  const Onboarding2Screen({Key? key}) : super(key: key);

  @override
  State<Onboarding2Screen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<Onboarding2Screen> {
  final PageController _pageController = PageController();
  bool isLastPage = false;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != currentPage) {
        setState(() {
          currentPage = page;
          isLastPage = currentPage == slides.length - 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (isLastPage) {
      // Navigate to home or main screen
      Navigator.pushReplacementNamed(context, Routes.INITIAL);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light purple background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // Skip button row
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.INITIAL);
                  },
                  child: const Text(
                    'Saltar',
                    style: TextStyle(
                      color: Color(0xFF6A14F0), // Deep purple
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              
              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(slideInfo: slides[index]);
                  },
                ),
              ),
              
              // Page indicator
              SmoothPageIndicator(
                controller: _pageController,
                count: slides.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Color(0xFF6A14F0), // Deep purple
                  dotColor: Color(0xFFD9D0F5), // Light purple
                  dotHeight: 6,
                  dotWidth: 6,
                  spacing: 4,
                  expansionFactor: 3,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Next button
              ElevatedButton(
                onPressed: _goToNextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A14F0), // Deep purple
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isLastPage ? 'Iniciar' : 'Siguiente',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final SlideInfo slideInfo;

  const OnboardingPage({
    Key? key,
    required this.slideInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image with purple bubble background
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background bubbles
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6A14F0),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 60,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D0F5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                right: 30,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9F78F6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Main image
              Image.asset(
                slideInfo.imageUrl,
                fit: BoxFit.contain,
                height: 240,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Title
        Text(
          slideInfo.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          slideInfo.caption,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 40),
      ],
    );
  }
}

// Para usarlo, agrega esta pantalla a tus rutas:
// routes: {
//   '/': (context) => const OnboardingScreen(),
//   '/home': (context) => const HomeScreen(), // Tu pantalla principal
// }