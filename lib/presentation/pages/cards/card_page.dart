import 'dart:math';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/datasources/credit_card_datasource.dart';
import 'package:paganini/data/repositories/credit_card_repository_impl.dart';
import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/domain/usecases/credit_cards_use_case.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:paganini/presentation/widgets/tex_form_fiedl_widget_second.dart';
import 'package:provider/provider.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController numberCreditCardController = TextEditingController();
  TextEditingController monthExpirationController = TextEditingController();
  TextEditingController yearExpirationController = TextEditingController();
  TextEditingController cvvCardController = TextEditingController();
  Color? selectedColor;
  String selectedCardType = "credit";

  String nameNewCard = "Nombre";
  String numberNewCard = "********************************";
  String monthExpirationNewCard = "00";
  String yearExpirationNewCard = "00";
  String cvvNewCard = "***";

  late CreditCardsUseCase addCreditCardUseCase = CreditCardsUseCase(
      repository: CreditCardRepositoryImpl(
          remoteDataSource: CreditCardRemoteDataSourceImpl()));
  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      setState(() {
        nameNewCard = nameController.text;
      });
    });

    numberCreditCardController.addListener(() {
      setState(() {
        numberNewCard = numberCreditCardController.text;
      });
    });
    monthExpirationController.addListener(() {
      setState(() {
        monthExpirationNewCard = monthExpirationController.text;
      });
    });
    yearExpirationController.addListener(() {
      setState(() {
        yearExpirationNewCard = yearExpirationController.text;
      });
    });

    cvvCardController.addListener(() {
      setState(() {
        cvvNewCard = cvvCardController.text;
      });
    });
  }

  bool _isLoading = true;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  bool isDateValid = true;
  bool isCvvValid = true;
  bool registerOneCard = false;

  @override
  Widget build(BuildContext context) {
    final cardProviderRead = context.read<CreditCardProvider>();
    final userId = context.read<UserProvider>().user!.uid;

    Future<void> registerCreditCard() async {
      setState(() {
        _isLoading = true;
      });
      debugPrint("Vamos a registrar la tarjeta");

      try {
        DatabaseReference cardRef =
            FirebaseDatabase.instance.ref('cards/$userId');
        String cardId = DateTime.now().millisecondsSinceEpoch.toString();
        Map<String, dynamic> cardData = {
          'cardNumber': numberCreditCardController.text.trim(),
          'expiryDate':
              "${yearExpirationController.text.trim()}/${monthExpirationController.text.trim()}",
          'cvv': cvvCardController.text.trim(),
          'cardName': nameController.text.trim(),
          'mount': 300,
          'type': selectedCardType
        };
        await cardRef.child(cardId).set(cardData);
        // ignore: use_build_context_synchronously
        AnimatedSnackBar(
          duration: const Duration(seconds: 3),
          builder: ((context) {
            return const MaterialAnimatedSnackBar(
              iconData: Icons.check,
              messageText: 'La tarjeta se agrego correctamente',
              type: AnimatedSnackBarType.success,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              backgroundColor: Color.fromARGB(255, 59, 141, 55),
              titleTextStyle: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 10,
              ),
            );
          }),
        ).show(context);
        setState(() {
          registerOneCard = true;
        });
      } catch (e) {
        debugPrint("Erro de REGISTRO DE TARJETAS AQUI!!!");
        debugPrint(e.toString());
        // Mostrar mensaje de error
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar la tarjeta: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.black,
      Colors.blue,
      const Color.fromARGB(255, 203, 159, 26),
      AppColors.primaryColor,
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const ContentAppBar(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            CreditCardWidget(
                balance: 0.0,
                width: 300,
                cardHolderFullName: nameNewCard,
                cardNumber: numberCreditCardController.text,
                validThru: "$monthExpirationNewCard/$yearExpirationNewCard",
                color: selectedColor ?? AppColors.primaryColor,
                cardType: selectedCardType,
                cvv: cvvNewCard),
            Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  child: Column(
                    children: [
                      const Text("Registra tu tarjeta",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                      const SizedBox(height: 10),
                      TextFormFieldSecondVersion(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor ingrese un nombre";
                          }
                          return null;
                        },
                        inputFormatters: const [],
                        onChanged: (value) {},
                        textAlign: TextAlign.start,
                        controller: nameController,
                        hintext: "Ponle un nombre",
                        textCapitalization: TextCapitalization.none,
                        icon: Icons.people,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldSecondVersion(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ingresa un numero de tarjeta porfa";
                          } else if (value.length < 16) {
                            return "El numero de tarjeta no puede ser menor a 16";
                          }
                          return null;
                        },
                        textAlign: TextAlign.start,
                        onChanged: (value) {},
                        textCapitalization: TextCapitalization.none,
                        hintext: "****************",
                        icon: Icons.credit_score_rounded,
                        keyboardType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(16)],
                        controller: numberCreditCardController,
                        inputBorder: InputBorder.none,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormFieldSecondVersion(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(2),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(0?[1-9]|1[0-2])$')),
                                ],
                                controller: monthExpirationController,
                                textCapitalization: TextCapitalization.none,
                                icon: Icons.calendar_month,
                                hintext: "xx",
                                onChanged: (value) {
                                  setState(() {
                                    isDateValid = value.length == 2;
                                  });
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 2) {
                                    setState(() {
                                      isDateValid = false;
                                    });
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.datetime),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "/",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 30),
                            ),
                          ),
                          Expanded(
                            child: TextFormFieldSecondVersion(
                                controller: yearExpirationController,
                                textCapitalization: TextCapitalization.none,
                                icon: Icons.calendar_month_outlined,
                                hintext: 'xx',
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(2),
                                  FilteringTextInputFormatter.allow(RegExp(
                                      r'[0-9/]')), // Permite solo números y "/"
                                ],
                                onChanged: (value) {},
                                validator: (value) {
                                  if (value == null || value.isEmpty) {}
                                  return null;
                                },
                                keyboardType: TextInputType.datetime),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormFieldSecondVersion(
                        controller: cvvCardController,
                        textCapitalization: TextCapitalization.none,
                        icon: Icons.lock,
                        hintext: "xxx",
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            setState(() {
                              isCvvValid = false;
                            });
                            return null;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 50,
                              // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: RadioListTile<String>(
                                  activeColor:
                                      const Color.fromARGB(255, 244, 244, 244),
                                  value: "credit",
                                  groupValue: selectedCardType,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedCardType = val!;
                                    });
                                  },
                                  title: const Text(
                                    "Credito",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(
                                      10)), // Color de fondo para todo el tile
                              child: RadioListTile<String>(
                                value: "debit",
                                activeColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                groupValue: selectedCardType,
                                onChanged: (val) {
                                  setState(() {
                                    selectedCardType = val!;
                                  });
                                },
                                title: const Text(
                                  "Debito",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: colors.map((color) {
                          bool isSelected = color == selectedColor;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = color;
                                debugPrint("Color selected: $color");
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: Colors.black,
                                        width:
                                            3) // Borde para el color seleccionado
                                    : null,
                              ),
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: color,
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ButtonSecondVersion(
                function: () async {
                  if (isCvvValid) {
                    if (_formKey.currentState!.validate()) {
                      bool? confirmAddCreditCard = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Agregar nueva tarjeta'),
                              content: const Text(
                                "¿Estás seguro de agregar la tarjeta?",
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
                                  text: "Agregar",
                                  function: () =>
                                      Navigator.of(context).pop(true),
                                  verticalPadding: 2,
                                  horizontalPadding: 3,
                                )
                              ],
                            );
                          });

                      if (confirmAddCreditCard == true) {
                        CreditCardEntity newCard = CreditCardEntity(
                          balance: 300,
                          id: Random().nextInt(2000),
                          cvv: cvvNewCard,
                          color: selectedColor ?? AppColors.primaryColor,
                          cardHolderFullName: nameNewCard,
                          cardNumber: numberNewCard,
                          cardType: selectedCardType,
                          validThru:
                              "$monthExpirationNewCard/$yearExpirationNewCard",
                          isFavorite: false,
                        );
                        await registerCreditCard();
                        await cardProviderRead.addCreditCard(newCard);
                        await Future.delayed(const Duration(seconds: 2));

                        await Navigator.pushReplacementNamed(
                            // ignore: use_build_context_synchronously
                            context,
                            Routes.WALLETPAGE);
                      }
                    }
                  }
                },
                text: registerOneCard ? "Registrar Otra" : "Registrar",
                verticalPadding: 2,
                horizontalPadding: 50,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
