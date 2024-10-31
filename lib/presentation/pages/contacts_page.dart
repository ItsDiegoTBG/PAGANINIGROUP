import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/contact_user.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const ContentAppBar(),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: myWidth * 0.08, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Contactos",
                            style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontSize: 24),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Busque y selecione un contacto",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: myHeight * 0.05,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: myWidth * 0.08,
                right: myWidth * 0.08,
              ),
              child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                    suffixIcon: Icon(
                      Icons.search_off_rounded,
                      size: 20,
                      color: AppColors.primaryColor,
                    ),
                    hintText: "Buscar",
                    hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic)),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(top:myWidth * 0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Tus contactos",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(width: 20,),
                  IconButton.filled(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            ContactUserWidget(width: myWidth*0.85,height: myHeight*0.10,nameUser: "Diego Contreras", phoneUser: "9999999999", numberAccount: "22032344040"),
            
          ],
        ));
  }
}
