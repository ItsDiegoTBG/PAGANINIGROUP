import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberCreditCardController = TextEditingController();
  TextEditingController dateExpirationController = TextEditingController();
  TextEditingController cvvCardController = TextEditingController();
  Color? selectedColor;
  String selectedCardType = "credit";

  String nameNewCard = "Nombre";
  String numberNewCard = "********************************";
  String dateExpirationNewCard = "00/00";
  String cvvNewCard = "***";
  @override
  void initState() {
    
    super.initState();
    nameController.addListener(() {
      setState(() {
        nameNewCard = nameController.text;
      });
    });

    numberCreditCardController.addListener((){
      setState(() {
        numberNewCard = numberCreditCardController.text;
      });
    });
    dateExpirationController.addListener((){
      setState((){
        dateExpirationNewCard = dateExpirationController.text;
      });
    });

    cvvCardController.addListener((){
      setState((){
        cvvNewCard = cvvCardController.text;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    final List<Color> colors = [
      Colors.green,
      Colors.black,
      Colors.blue,
      Colors.amber,
      AppColors.primaryColor,
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const ContentAppBar(),
      ),
      body: SizedBox(
        height: myHeight,
        width: myWidth,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: myWidth * 0.08,
            ),
            child: const Text(
              'Agrega una nueva tarjeta a tu billetera',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
          SizedBox(
            height: myHeight * 0.02,
          ),
          Expanded(
            child: ListView(
              children: [
                Stack(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            left: myWidth * 0.06,
                            right: myWidth * 0.06,
                            top: myHeight * 0.08),
                        child: Container(
                          height: myHeight * 0.62,
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
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: myWidth * 0.06,
                                    right: myWidth * 0.06,
                                    top: myHeight * 0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: myWidth * 0.03),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: TextFormField(
                                    textCapitalization: TextCapitalization.characters,
                                    onChanged: (value) {},
                                    controller: nameController,
                                    decoration: InputDecoration(
                                        prefixIconColor: AppColors.primaryColor,
                                        prefixIcon: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.emoji_people),
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Porfavor ingresa el nombre',
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 14)),
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
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: myWidth * 0.06,
                                    right: myWidth * 0.06,
                                    top: myHeight * 0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: myWidth * 0.03),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {},
                                    controller: numberCreditCardController,
                                    decoration: InputDecoration(
                                        prefixIconColor: AppColors.primaryColor,
                                        prefixIcon: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child:
                                              Icon(Icons.credit_score_rounded),
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'xxxxxxxxxxxxxxxx',
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 14)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: myHeight * 0.01,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: myWidth * 0.06,
                                    right: myWidth * 0.10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.only(right: myWidth * 0),
                                        child: const Text(
                                          'Fecha de Expiracion',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        )),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: myWidth * 0),
                                        child: const Text(
                                          'Cvv',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: myWidth * 0.15,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        onChanged: (value){},
                                        keyboardType: TextInputType.datetime,
                                        controller: dateExpirationController,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                color: Colors.grey.shade400),
                                            border: InputBorder.none,
                                            hintText: "xx/xx"),
                                      ),
                                    ),
                                    Container(
                                      width: myWidth * 0.15,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        onChanged: (value) {},
                                        controller: cvvCardController,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                color: Colors.grey.shade400),
                                            border: InputBorder.none,
                                            hintText: "xxxx"),
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
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: RadioListTile<String>(
                                          activeColor: AppColors.secondaryColor,
                                          value: "credit",
                                          groupValue: selectedCardType,
                                          onChanged: (val) {
                                            setState(() {
                                              selectedCardType = val!;
                                            });
                                          },
                                          title: const Text(
                                            "Credito",
                                            style:
                                                TextStyle(color: Colors.white),
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
                                          activeColor: AppColors.secondaryColor,
                                          groupValue: selectedCardType,
                                          onChanged: (val) {
                                            setState(() {
                                              selectedCardType = val!;
                                            });
                                          },
                                          title: const Text(
                                            "Debito",
                                            style:
                                                TextStyle(color: Colors.white),
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
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
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
                                        radius: 20,
                                        backgroundColor: color,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        )),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 0),
                        child: CreditCardWidget(
                            width: 300,
                            cardHolderFullName: nameNewCard,
                            cardNumber: numberNewCard,
                            validThru: dateExpirationNewCard,
                            color: selectedColor ?? AppColors.primaryColor,
                            cardType: selectedCardType,
                            cvv: cvvNewCard),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: myWidth * 0.1),
            child: ButtonSecondVersion(
              function: () {
                setState(() {});
              },
              text: "Aceptar",
              verticalPadding: 2,
              horizontalPadding: 50,
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: AppColors.primaryColor,
        focusColor: AppColors.secondaryColor,
        foregroundColor:Colors.white,
        child: const Icon(Icons.arrow_back_sharp),
      ),
    );
  }
}
