import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paganini/core/device/qr_code_scanner.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/data/models/transaction_model.dart';
import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/domain/entity/user_entity.dart';
import 'package:paganini/helpers/show_qr.dart';
import 'package:paganini/presentation/pages/payment/payment_page.dart';
import 'package:paganini/presentation/pages/recharge/recharge_page.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';

import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/widgets/container_action_button.dart';
import 'package:paganini/presentation/widgets/floating_button_paganini.dart';
import 'package:paganini/presentation/widgets/list_title_transaction.dart';
import 'package:paganini/presentation/widgets/qr_container.dart';
import 'package:provider/provider.dart';

import '../../widgets/credit_card_ui.dart';
//import 'package:paganini/core/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserEntity? userEntity;
  bool _isInitialized = false;
  bool showAllMovements = false; // Estado para controlar la expansión.

  List<TransactionModel> movements = [
    TransactionModel(
        name: 'Grocery Shopping',
        originator: 'Walmart',
        amount: -50.75,
        date: '13/12/2022'),
    TransactionModel(
        name: 'Utility Payment',
        originator: 'Electric Company',
        amount: -30.00,
        date: '15/12/2022'),
    TransactionModel(
        name: 'Received Transfer',
        originator: 'John Doe',
        amount: 100.00,
        date: '14/12/2022'),
   
  ];

  List<TransactionModel> filteredMovements = []; // Lista filtrada.
  String searchQuery = ""; // Consulta de búsqueda.

  @override
  void initState() {
    super.initState();
    filteredMovements = movements; // Inicializa con todos los movimientos.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final creditCardProvider =
          Provider.of<CreditCardProvider>(context, listen: false);
      if (userProvider.currentUser != null) {
        userEntity = userProvider.currentUser;
        creditCardProvider.fetchCreditCards(userEntity!.id);
      }
      _isInitialized = true; // Asegura que esto se ejecute solo una vez.
    }
  }

  String? _result;
  void setResult(String result) {
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    final saldoProviderWatch = context.watch<SaldoProvider>();
    final creditCardProviderWatch = context.watch<CreditCardProvider>();
    final creditCards = creditCardProviderWatch.creditCards;
    String nombreCompleto = userEntity?.firstname ?? 'usuario no disponible';
    String primerNombre = nombreCompleto.split(' ').first;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 30, bottom: 1),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Bienvenido, $primerNombre!",
                    style: const TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              height: 105,
              width: 360,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 5),
                    child: Text(
                      "Saldo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "\$${saldoProviderWatch.saldo}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 33,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors
                                .secondaryColor, // Cambia el color del fondo
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add,
                                color: AppColors
                                    .primaryColor), // Cambia el color del icono
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.RECHARGE);
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            _CreditCardsView(creditCards: creditCards),
            const Padding(
              padding: EdgeInsets.only(top: 7, left: 30, bottom: 1),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Acciones Rápidas",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  )),
            ),
            _QuickAccessView(size: size),
             Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Últimos Movimientos",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(onPressed: (){
                        Navigator.pushNamed(context, Routes.HISTORYPAGE);
                      }, icon: const Icon(Icons.search)),
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(left: 13),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: showAllMovements
                    ? filteredMovements.length
                    : (filteredMovements.length > 3
                        ? 3
                        : filteredMovements.length),
                itemBuilder: (context, index) {
                  final TransactionModel transaction = filteredMovements[index];
                  return ListTitleTransaction(transaction: transaction,paddingRight: 0);
                },
              ),
            ),
          ],
        ),
      ),
      /*floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
        floatingActionButton: FloatingButtonPaganini(
          isQrPrincipal: false,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QrCodeScanner(setResult: setResult),
              ),
            );
          },
          iconData: Icons.qr_code_scanner_rounded,
        )*/
    );
  }
}

class _QuickAccessView extends StatelessWidget {
  const _QuickAccessView({
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    void setResult(String result) {}
    final userProviderWatch = context.watch<UserProvider>();
    final qrContainer = QrContainer(data: userProviderWatch.currentUser?.id);
    final userName =
        userProviderWatch.currentUser?.firstname ?? "Usuario no disponible";
    return Wrap(
      spacing: 15,
      runSpacing: 10,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.TRANSFERPAGE);
          },
          child: ContainerActionButton(
            width: size.width * 0.20,
            height: size.height * 0.10,
            text: "Enviar Dinero",
            iconData: FontAwesomeIcons.moneyBillTransfer,
            color: AppColors.primaryColor,
          ),
        ),
        GestureDetector(
          onTap: () {
            ShowQr.showQrDialog(context, qrContainer, userName);
          },
          child: ContainerActionButton(
            width: size.width * 0.20,
            height: size.height * 0.10,
            text: "QR",
            iconData: Icons.qr_code_2_outlined,
            color: AppColors.primaryColor,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QrCodeScanner(setResult: setResult),
              ),
            );
          },
          child: ContainerActionButton(
            width: size.width * 0.20,
            height: size.height * 0.10,
            text: "Escanear QR",
            iconData: Icons.qr_code_scanner_rounded,
            color: AppColors.primaryColor,
          ),
        ),
        GestureDetector(
          onTap: () {
            debugPrint("Nueva funcionalidad de guardar el saldo");
            Navigator.pushNamed(context, Routes.RETURNAMOUNTPAGE);
          },
          child: ContainerActionButton(
            width: size.width * 0.20,
            height: size.height * 0.10,
            text: "Retornar saldo",
            iconData: Icons.swap_vert_rounded,
            color: AppColors.primaryColor,
          ),
        ),
        GestureDetector(
          onTap: () {
            debugPrint("Muestra el historial");
            Navigator.pushNamed(context, Routes.HISTORYPAGE);
          },
          child: ContainerActionButton(
            width: size.width * 0.20,
            height: size.height * 0.10,
            text: "Historial",
            iconData: Icons.history_outlined,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}

class _CreditCardsView extends StatelessWidget {
  const _CreditCardsView({
    required this.creditCards,
  });

  final List<CreditCardEntity> creditCards;

  Future<bool> _simulateLoading() async {
    await Future.delayed(const Duration(milliseconds: 1600));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 140,
        width: 500,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: creditCards.isNotEmpty
                  ? creditCards.length > 1
                      ? Swiper(
                          itemWidth: 400,
                          itemHeight: 190,
                          loop: true,
                          duration: 500,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final card = creditCards[index];
                            debugPrint("El card es: ${card.cardNumber}");
                            return Stack(
                              children: [
                                SizedBox(
                                  width: 400,
                                  child: CreditCardWidget(
                                    balance: card.balance,
                                    cardHolderFullName: card.cardHolderFullName,
                                    cardNumber: card.cardNumber,
                                    validThru: card.validThru,
                                    cardType: card.cardType,
                                    cvv: card.cvv,
                                    color: card.color,
                                    isFavorite: false,
                                  ),
                                ),
                                if (card
                                    .isFavorite) // Mostrar la estrella solo si la tarjeta es favorita
                                  const Positioned(
                                    top: 10,
                                    right:
                                        10, // Coloca la estrella a la derecha
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 30,
                                    ),
                                  ),
                              ],
                            );
                          },
                          itemCount: creditCards.length,
                          layout: SwiperLayout.TINDER,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: SizedBox(
                            width: 360,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 360,
                                  child: CreditCardWidget(
                                      balance: creditCards[0].balance,
                                      cardHolderFullName:
                                          creditCards[0].cardHolderFullName,
                                      cardNumber: creditCards[0].cardNumber,
                                      validThru: creditCards[0].validThru,
                                      cardType: creditCards[0].cardType,
                                      cvv: creditCards[0].cvv,
                                      color: creditCards[0].color,
                                      isFavorite: false),
                                ),
                                if (creditCards[0]
                                    .isFavorite) // Mostrar la estrella solo si la tarjeta es favorita
                                  const Positioned(
                                    top: 10,
                                    right:
                                        10, // Coloca la estrella a la derecha
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 30,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Aun no tienes una tarjeta registrada",
                            style:
                                TextStyle(fontSize: 18, color: Colors.black)),
                        const Text("Registra una ahora",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primaryColor)),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: AppColors
                                    .primaryColor, // Cambia el color del fondo
                                borderRadius: BorderRadius.circular(
                                    30)), // Agrega bordes redondeados

                            child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, Routes.CARDPAGE);
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.arrowRightFromBracket,
                                  size: 20,
                                )))
                      ],
                    ))),
        ));
  }
}
