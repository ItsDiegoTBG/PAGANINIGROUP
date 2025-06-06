import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';

import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/helpers/show_animated_snackbar.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version_icon.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:paganini/presentation/widgets/floating_button_paganini.dart';

import 'package:provider/provider.dart';

class CardDeletePage extends StatefulWidget {
  const CardDeletePage({super.key});

  @override
  State<CardDeletePage> createState() => _CardDeletePageState();
}

class _CardDeletePageState extends State<CardDeletePage> {
  @override
  Widget build(BuildContext context) {
    final creditCardProviderWatch = context.watch<CreditCardProvider>();
    final creditCardProviderRead = context.read<CreditCardProvider>();
    final creditCards = creditCardProviderWatch.creditCards;
    final userId = context.read<UserProvider>().currentUser!.id;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const ContentAppBar(),
      ),
     // backgroundColor: Colors.white,
      body: creditCards.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No tiene tarjetas registradas",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 20,),
                ButtonSecondVersionIcon(
                  text: "Regresar",
                  function: () {
                    Navigator.pop(context);
                  },
                  icon: Icons.arrow_back_ios_rounded,
                  iconAlignment: IconAlignment.start,
                ),
              ],
            ))
          : creditCardListView(creditCards, creditCardProviderRead, userId),
      floatingActionButton: FloatingButtonPaganini(
        onPressed: () {
          Navigator.pop(context);
        },
        iconData: Icons.arrow_back_rounded,
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Padding creditCardListView(List<CreditCardEntity> creditCards,
      CreditCardProvider creditCardProviderRead, String userId) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 30),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(childCount: creditCards.length,
                (context, index) {
              final card = creditCards[index];
              return Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                child: Container(
                  //padding: const EdgeInsets.all(10),
                  height: 230, // color: Colors.white,color: Colors.white,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: AppColors.primaryColor,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: SizedBox(
                          height: 200,
                          child: CreditCardWidget(
                            balance: card.balance,
                            cardHolderFullName: card.cardHolderFullName,
                            cardNumber: card.cardNumber,
                            validThru: card.validThru,
                            cardType: card.cardType,
                            cvv: card.cvv,
                            color: card.color,
                            isFavorite: card.isFavorite,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          // Mostrar el cuadro de diálogo de confirmación
                          bool? confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmar eliminación'),
                                content: const Text(
                                  '¿Estás seguro de que deseas eliminar esta tarjeta?',
                                  style: TextStyle(fontSize: 18),
                                ),
                                actions: [
                                  ButtonSecondVersion(
                                      backgroundColor: AppColors.secondaryColor,
                                      verticalPadding: 2,
                                      horizontalPadding: 3,
                                      text: "Cancelar",
                                      function: () =>
                                          Navigator.of(context).pop(false)),
                                  ButtonSecondVersion(
                                      backgroundColor: AppColors.primaryColor,
                                      verticalPadding: 2,
                                      horizontalPadding: 3,
                                      text: "Eliminar",
                                      function: () =>
                                          Navigator.of(context).pop(true)),
                                ],
                              );
                            },
                          );

                          // Si el usuario confirma la eliminación
                         if (confirmDelete == true) {
                          // Mostrar el indicador de progreso
                        showDialog(
                          context: context,
                          barrierDismissible: false, // Evita que se cierre al tocar fuera del diálogo
                          builder: (BuildContext context) {
                            return const Center(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                     Text("Eliminando tarjeta...",style: TextStyle(fontSize: 18,color: Colors.white),),
                                    CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      // Simular un retraso de 3 segundos
                      await Future.delayed(const Duration(seconds: 5));

                      // Llamar al método de eliminación
                      await creditCardProviderRead.deleteCreditCard(userId, index);

                      // Cerrar el indicador de progreso
                      Navigator.of(context).pop();

                     ShowAnimatedSnackBar.show(context, "Tarjeta eliminada exitosamente", Icons.check, AppColors.greenColors);

  } 

                        },
                        icon: const Icon(
                          Icons.delete_rounded,
                          size: 40,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
