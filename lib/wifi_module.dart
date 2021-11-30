

import 'package:eval_ex/built_ins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

class WifiModule extends StatefulWidget {
  @override
  _WifiModuleState createState() => _WifiModuleState();
}

class _WifiModuleState extends State<WifiModule> {

  WiFiHunterResult wiFiHunterResult = WiFiHunterResult();
  Color huntButtonColor = const Color.fromARGB(255, 53, 140, 151);


  Future<void> huntWiFis() async {
    setState(() => huntButtonColor = Colors.lightBlue);

    try {
      wiFiHunterResult = (await WiFiHunter.huntWiFiNetworks)!;
    } on PlatformException catch (exception) {
      print(exception.toString());
    }

    if (!mounted) return;

    setState(() => huntButtonColor = Colors.lightBlue);
  }

  calculateDistance(num fspl, num k, num f){
    return -((10*(fspl - (k) - (20*log10(f))))/20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Módulo WiFi Testing'),
        backgroundColor: const Color.fromARGB(255, 53, 140, 151),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(huntButtonColor)),
                  onPressed: () => huntWiFis(),
                  child: const Text('Iniciar')
              ),
            ),
            wiFiHunterResult.results.isNotEmpty ? Container(
              margin: const EdgeInsets.only(bottom: 20.0, left: 30.0, right: 30.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(wiFiHunterResult.results.length, (index) =>
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                            leading: Text(wiFiHunterResult.results[index].level.toString() + ' dbm'),
                            title: Text(wiFiHunterResult.results[index].SSID),
                            subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('BSSID : ' + wiFiHunterResult.results[index].BSSID),
                                  Text('CAPACIDADES : ' + wiFiHunterResult.results[index].capabilities),
                                  Text('FRECUENCIA : ' + wiFiHunterResult.results[index].frequency.toString()),
                                  Text('ANCHO DE BANDA : ' + wiFiHunterResult.results[index].channelWidth.toString()),
                                  Text('MARCA DE TIEMPO : ' + wiFiHunterResult.results[index].timestamp.toString()),
                                  Text('DISTANCIA : ' + calculateDistance(wiFiHunterResult.results[index].level,-87.55, wiFiHunterResult.results[index].frequency).toString())
                                ]
                            )
                        ),
                      )
                  )
              ),
            ) : Container()
          ],
        ),
      ),
    );
  }
}
