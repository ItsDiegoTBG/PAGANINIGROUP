import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/datasources/credit_card_datasource.dart';
import 'package:paganini/data/repositories/credit_card_repository_impl.dart';
import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/domain/usecases/credit_cards_use_case.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
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

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  bool isDateValid = true;
  bool isCvvValid = true;

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    final cardProviderRead = context.read<CreditCardProvider>();
    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.black,
      Colors.blue,
      Colors.amber,
      AppColors.primaryColor,
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const ContentAppBar(),
      ),
      body: SizedBox(
        height: myHeight,
        width: myWidth,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: myWidth * 0.08,
              ),
              child: const Text(
                'Agrega una nueva tarjeta a tu billetera',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            SizedBox(
              height: myHeight * 0.02,
            ),
            uiRegisterCreditCard(myWidth, myHeight, colors),
            Padding(
              padding: const EdgeInsets.only(top: 30),
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
                          balance: 0,
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

                        await cardProviderRead.addCreditCard(newCard);

                        await Navigator.pushReplacementNamed(
                            context, Routes.WALLETPAGE);
                      }
                    }
                  }
                },
                text: "Aceptar",
                verticalPadding: 2,
                horizontalPadding: 50,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Flexible uiRegisterCreditCard(
      double myWidth, double myHeight, List<Color> colors) {
    return Flexible(
      fit: FlexFit.loose,
      child: Form(
        key: _formKey,
        child: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: myWidth * 0.06,
                    right: myWidth * 0.06,
                    top: myHeight * 0.08),
                child: Container(
                  height: myHeight * 0.64,
                  width: myWidth * 0.88,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 214, 199, 249),
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: myHeight * 0.15,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: myWidth * 0.06),
                        child: const Text(
                          'Nombre de la Tarjeta',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: myWidth * 0.06,
                            right: myWidth * 0.06,
                            top: myHeight * 0),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: myWidth * 0.03),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8)),
                          child: TextFormFieldSecondVersion(
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
                            hintext: "Por favor ingresa el nombre",
                            textCapitalization: TextCapitalization.none,
                            icon: Icons.emoji_people_rounded,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: myHeight * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: myWidth * 0.06),
                        child: const Text(
                          'Numero de Tarjeta',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: myWidth * 0.06,
                            right: myWidth * 0.06,
                            top: myHeight * 0),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: myWidth * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormFieldSecondVersion(
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(16)
                            ],
                            controller: numberCreditCardController,
                            inputBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: myHeight * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: myWidth * 0.06, right: myWidth * 0.10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: myWidth * 0),
                              child: Row(
                                children: [
                                  const Text(
                                    'Fecha de Expiración',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  if (isDateValid ==
                                      false) // Si la fecha no es válida, muestra el asterisco rojo
                                    const Text(
                                      ' *',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: myWidth * 0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Cvv',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    if (isCvvValid == false)
                                      const Text(
                                        ' *',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.red),
                                      ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: myWidth * 0.06,
                            right: myWidth * 0.06,
                            top: myHeight * 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: myWidth * 0.15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
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
                                    onChanged: (value) {
                                      setState(() {
                                        isDateValid = value.length == 2;
                                      });
                                    },
                                    keyboardType: TextInputType.datetime,
                                    controller: monthExpirationController,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(0?[1-9]|1[0-2])$')),
                                    ],
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0,
                                              color: isCvvValid
                                                  ? Colors.grey.shade400
                                                  : Colors.red),
                                        ),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400),
                                        border: InputBorder.none,
                                        hintText: "xx"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: myWidth * 0.01),
                                  child: const Text("/"),
                                ),
                                Container(
                                  width: myWidth * 0.15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    onChanged: (value) {},
                                    keyboardType: TextInputType.datetime,
                                    controller: yearExpirationController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {}
                                      return null;
                                    },
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      FilteringTextInputFormatter.allow(RegExp(
                                          r'[0-9/]')), // Permite solo números y "/"
                                    ],
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0,
                                              color: isCvvValid
                                                  ? Colors.grey.shade400
                                                  : Colors.red),
                                        ),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400),
                                        border: InputBorder.none,
                                        hintText: "xx"),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: myWidth * 0.15,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
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
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(3),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                controller: cvvCardController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0,
                                          color: isCvvValid
                                              ? Colors.grey.shade400
                                              : Colors.red),
                                    ),
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade400),
                                    border: InputBorder.none,
                                    hintText: "xxx"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: myHeight * 0.03,
                      ),
                      //radios de credit or debit include in future gift cards
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
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
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
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
                      ),
                      SizedBox(
                        height: myHeight * 0.02,
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
                                radius: 10,
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
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: CreditCardWidget(
                  balance: 0.0,
                  width: 300,
                  cardHolderFullName: nameNewCard,
                  cardNumber: numberCreditCardController.text,
                  validThru: "$monthExpirationNewCard/$yearExpirationNewCard",
                  color: selectedColor ?? AppColors.primaryColor,
                  cardType: selectedCardType,
                  cvv: cvvNewCard),
            ),
          ],
        ),
      ),
    );
  }
}
