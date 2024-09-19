import 'package:flutter/material.dart';
import 'package:paganini/utils/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: SizedBox(
                        width: 220,
                        height: 100,
                        child: Image.asset(
                            "assets/image/paganini_logo_horizontal_morado_lila.png")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, "initial_page");
                        },
                        icon: const Icon(Icons.logout_rounded)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              height: 130,
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Saldo",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),

                  //boton de agregar 
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:  BorderRadius.circular(10),
                      )
                    ),
                    child: const Padding(
                      padding:  EdgeInsets.only(left: 30,right: 30,top: 5,bottom: 5),
                      child:  Text("Agregar",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 22),),
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(top: 20,left: 12,right: 8,bottom: 8),
              child: Align(
                alignment: Alignment.topLeft,
                  child:  Text(
                "Acciones Rápidas",
                style: TextStyle(fontStyle: FontStyle.italic,fontSize: 25,fontWeight: FontWeight.bold),
              )),
            ),
          ],
        ));
  }
}
