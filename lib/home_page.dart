import 'package:ble_testing/custom_outlined_button.dart';
import 'package:ble_testing/device_detailed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

import 'package:timer_count_down/timer_count_down.dart';

class HomePage extends StatefulWidget {

  bool isReading = false;
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  int counter = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController pc = new PageController();



  _addDeviceToList(final BluetoothDevice device){
    if(!widget.devicesList.contains(device)){
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }


  _calculateDistante(int rssi, int power){
    return ((pow(10, (power-rssi)/(10*4)))/(100)).toStringAsFixed(2);
  }

  Column _buildListViewOfDevices() {
    List<GestureDetector> containers = <GestureDetector>[];
    for (BluetoothDevice device in widget.devicesList) {
      String deviceKey = device.manofacturerData.values.toList().isNotEmpty? device.manofacturerData.keys.toString() : '0';
        if(deviceKey != '0'){
          setState(() {
            widget.counter = containers.length;
          });
          containers.add(
            GestureDetector(
              onTap: (){
                Get.to(DeviceDetailed(
                    deviceKey,
                    device.name == '' ? 'Anónimo' : device.name,
                    device.id.toString(),
                    device.type.toString(),
                    _calculateDistante(device.rssi, device.power) + " m."
                ));
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right:20),
                              child: Icon(Icons.phone_android, size: 35, color: Colors.blue,),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        device.name == '' ? 'Anónimo' : device.name,
                                        style: GoogleFonts.roboto(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "ID: " + device.id.toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "TIPO: " + device.type.toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ),
                                Text(
                                  "DISTANCIA: " + _calculateDistante(device.rssi, device.power) + " m.",
                                  style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              ],
                            ),
                          ],
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

    return Column(
      children: <Widget>[
        ...containers,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: !widget.isReading ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Estimación de aforo',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 33, 118, 129),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Al presionar el botón iniciar, iniciará el proceso de estimación.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Center(
                        child: Image.asset('assets/images/radarimage.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: CustomOutlinedButton(
                          onPressed: (){
                            setState(() {
                              widget.devicesList.clear();
                              _buildListViewOfDevices();
                              widget.isReading = true;
                              widget.flutterBlue.connectedDevices
                                  .asStream()
                                  .listen((List<BluetoothDevice> devices) {
                                for (BluetoothDevice device in devices) {
                                  _addDeviceToList(device);
                                }
                              });
                              widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
                                for (ScanResult result in results) {
                                  result.device.setRssi(result.rssi);
                                  result.device.setPower(result.advertisementData.txPowerLevel == null ? 0 : result.advertisementData.txPowerLevel!);
                                  result.device.setManofacturerData(result.advertisementData.manufacturerData);

                                  _addDeviceToList(result.device);
                                }
                              });
                              widget.flutterBlue.startScan();
                            });
                          },
                          text: 'Iniciar',
                          isFilled: true,
                        color: Color.fromARGB(255, 108, 193, 144),
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ): Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Estimación de aforo',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 33, 118, 129),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset('assets/animations/nearby.json'),
                      Image.asset('assets/images/girl.png')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Analizando...',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 33, 118, 129),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Dispositivos encontrados: ${widget.counter}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                Countdown(
                  seconds: 30,
                  build: (BuildContext context, double time) => Text(
                      time.toString() + ' s',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 33, 118, 129),
                    ),
                  ),
                  interval: Duration(milliseconds: 100),
                  onFinished: () {
                    pc.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                    widget.flutterBlue.stopScan();
                  },
                ),
                CustomOutlinedButton(
                    onPressed: (){
                      setState(() {
                        widget.isReading = false;
                        widget.flutterBlue.stopScan();
                      });
                      pc.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                    },
                    text: 'Detener',
                    color: Colors.red,
                    isFilled: true
                ),
              ],
            ),
          ),
          SingleChildScrollView(child: _buildListViewOfDevices())
        ],
      ),
    );
  }
}

class _Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Estimación de aforo',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 33, 118, 129),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only( bottom: 20),
            child: Text(
              'Usando como referencia el punto en el que te encuentras, la estimación de personas al rededor de tí en un esfera con su respectivo rango, es la siguiente:',
              textAlign: TextAlign.justify,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/1.png'),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menos de 2 metros',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 33, 118, 129),
                        ),
                      ),
                      Text(
                        '+/- 2 persona',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/2.png'),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menos de 5 metros',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 33, 118, 129),
                        ),
                      ),
                      Text(
                        '+/- 2 personas',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/3.png'),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menos de 10 metros',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 33, 118, 129),
                        ),
                      ),
                      Text(
                        '+/- 6 personas',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
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
                    text: 'SALIR',
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
                    },
                    text: 'REPORTAR',
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
    );
  }
}
