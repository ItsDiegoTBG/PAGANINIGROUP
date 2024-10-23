import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const ContentAppBar(),
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
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
                      SizedBox(
                        height: 200,
                        child: CreditCardWidget(
                          cardHolderFullName: card.cardHolderFullName,
                          cardNumber: card.cardNumber,
                          validThru: card.validThru,
                          cardType: card.cardType,
                          cvv: card.cvv,
                          color: card.color,
                          isFavorite: card.isFavorite,
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
                                      backgroundColor: Colors.green,
                                      verticalPadding: 2,
                                      horizontalPadding: 3,
                                      text: "Cancelar",
                                      function: () =>
                                          Navigator.of(context).pop(false)),
                                  ButtonSecondVersion(
                                      backgroundColor: Colors.red,
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
                            await creditCardProviderRead
                                .deleteCreditCard(card.id);
                            // Aquí puedes agregar código para actualizar la interfaz o mostrar un mensaje
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
      floatingActionButton: const FloatingButtonNavBarQr(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomMainAppBar(),
    );
  }
}
