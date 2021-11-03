import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceDetailed extends StatelessWidget {

  String deviceKey;
  String name;
  String id;
  String tipo;
  String distancia;

  DeviceDetailed(
      this.deviceKey,
      this.name,
      this.id,
      this.tipo,
      this.distancia,
      {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: (){
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios)
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Center(
                  child: Icon(Icons.phone_android, size: 100, color: Colors.blue,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "INFORMACIÓN DEL DISPOSITIVO",
                  style: GoogleFonts.roboto(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "NOMBRE: " + name,
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "ID: " + id,
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(
                  "DISTANCIA: " + distancia,
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                  ),
                ),
              ),
              Divider(thickness: 4,),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  "INFORMACIÓN DEL FABRICANTE",
                  style: GoogleFonts.roboto(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "COMPANY ID: " + deviceKey,
                  style: GoogleFonts.roboto(
                    fontSize: 20
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
