import 'package:flutter/material.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version_icon.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';
import 'package:paganini/presentation/widgets/smooth_page_indicator.dart';
import 'package:paganini/utils/colors.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

final List<Map<String, String>> tarjetas = [
    {
      'nombre': 'Cristhian Santacruz',
      'numero': '4351056433584414',
      'vencimiento': '10/24',
      'cvv': '123',
      'tipoTarjeta': 'debit',
      'isFavorite': 'true',
    },
    {
      'nombre': 'Maria Gonzalez',
      'numero': '9876543212345671',
      'vencimiento': '05/25',
      'cvv': '456',
      'tipoTarjeta': 'credit',
      'isFavorite': 'false',
    },
    {
      'nombre': 'Carlos Ruiz',
      'numero': '9876432109876543',
      'vencimiento': '12/23',
      'cvv': '789',
      'tipoTarjeta': 'debit',
      'isFavorite': 'false',
    },
    {
      'nombre': 'Andrea Pérez',
      'numero': '6543120987654321',
      'vencimiento': '07/26',
      'cvv': '321',
     'tipoTarjeta': 'credit',  
      'isFavorite': 'true',
    },
    {
      'nombre': 'Luis Martinez',
      'numero': '5432167890123456',
      'vencimiento': '11/22',
      'cvv': '654',
     'tipoTarjeta': 'debit',
      'isFavorite': 'false',
    },
  ];

  

class _WalletPageState extends State<WalletPage> {

  late  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0); 
  }

   @override
  void dispose() {
    _pageController.dispose(); 
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const ContentAppBar(),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  height: 130,
                  width: 360,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Column(                
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 40,top: 8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Saldo',
                            style: TextStyle(
                              color: Colors.white, // Color del texto
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              10), // Espacio entre el texto de saldo y el valor
                      Text(
                        '\$688', // Aquí pones el valor que quieres mostrar
                        style: TextStyle(
                          color: Colors.white, // Color del texto
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ],
                  ),
                )),
            const Padding(
              padding: EdgeInsets.only(top: 5,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonSecondVersion(text: "Agregar"),
                  SizedBox(width: 10,),
                  ButtonSecondVersion(text: "Transferir")
                ],
              ),
            ),


            //tarjatas
            SizedBox(
              height: 190,
              child: PageView.builder(
                controller: _pageController,
                itemCount: tarjetas.length,
                itemBuilder:(context,index) {
                  final tarjeta = tarjetas[index];
                  return AnimatedBuilder(
                    animation: _pageController, 
                    builder: (context,child){
                       double value = 1.0;
                       if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0); // Reduce la escala
                        } else {
                          value = index == 0 ? 1.0:0.7;
                        }  
                      return Transform.scale(
                        scale: value,
                        child: Opacity(opacity: 1,
                            child: CreditCardWidget(cardHolderFullName: tarjeta['nombre']!,cardNumber: tarjeta['numero']!,validThru: tarjeta['vencimiento']!,cardType: tarjeta['tipoTarjeta']!,cvv: tarjeta['cvv']!,isFavorite: tarjeta['isFavorite']!.toLowerCase() != "false",)
                            ),
                      ); 
                    }
                  );
                } 
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SmoothPageIndicatorWidget(pageController: _pageController,totalCounts: tarjetas.length),
            ),
            const SizedBox(height: 40,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonSecondVersionIcon(text: "Eliminar", icon: Icons.delete_rounded, iconAlignment: IconAlignment.end),
               ButtonSecondVersionIcon(text: "Nueva", icon: Icons.add_card_rounded, iconAlignment: IconAlignment.start),
                
              ],
            )

          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FloatingButtonNavBarQr(),
      bottomNavigationBar: const BottomMainAppBar(),
    );
  }
}
