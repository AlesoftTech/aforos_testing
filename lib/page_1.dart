import 'package:ble_testing/custom_outlined_button.dart';
import 'package:ble_testing/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '¿Cómo funciona?',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 33, 118, 129),
              ),
            ),
            Flexible(
              child: Image.asset('assets/images/page1.png'),
            ),
            RichText(
              textAlign: TextAlign.justify,
              text: new TextSpan(
                children: <TextSpan>[
                  new TextSpan(
                      text: 'Mediante el uso del señales Bluetooth y Wi-Fi  de tú telefono podemos calcular ',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black
                    )
                  ),
                  new TextSpan(
                      text: 'anonímamente un número estimado de las personas que están cerca a tí. ',
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      )
                  ),
                  new TextSpan(
                      text: 'De igual manera nos ayudarás controlar los aforos del campus.',
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black
                      )
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomOutlinedButton(
                        onPressed: (){},
                        text: 'VOLVER',
                        isFilled: true,
                      color: Color.fromARGB(255, 53, 140, 151),
                      textColor: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: CustomOutlinedButton(
                      onPressed: (){
                        Get.to(HomePage());
                      },
                      text: 'CONTINUAR',
                      isFilled: true,
                      color: Color.fromARGB(255, 108, 193, 144),
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
