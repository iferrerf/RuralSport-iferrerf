import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiY2VxdWUiLCJhIjoiY2tkM3F4MzV1MHl4NjJ0bndzdWdmNWI5cSJ9._jBKVgTDTR2W1auJYOgiMg';

final poliIglesuela = LatLng(40.48157221456962, -0.32274539967352234);
final poliCantavieja = LatLng(40.52532706763187, -0.4047808490225969);
final padelMirambel = LatLng(40.591989, -0.342386);
final padelIglesuela = LatLng(40.48186855251597, -0.3233418361936311);
final tenisCantavieja = LatLng(40.523244, -0.404215);
final zoom = LatLng(40.547240, -0.348118);

class MapPage extends StatelessWidget {
  MapPage({super.key});

  String textoPoli =
      "- Multideporte en espacio cerrado\n- Abierta todo el año\n- Uso en horario de actividades";
  String textoPadel = "- Pista al aire libre\n- Abierta todo el año";
  String rutaImagenes = "assets/pistas/";

  void mostrarAlertaIOS(
      BuildContext context, String titulo, String mensaje, String rutaImagen) {
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: ((context) {
        return CupertinoAlertDialog(
          title: Center(child: Text(titulo)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(rutaImagen),
              SizedBox(
                height: 10,
              ),
              Text(mensaje),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok')),
          ],
        );
      }),
    );
  }

  void mostrarAlertaAndroid(
      BuildContext context, String titulo, String mensaje, String rutaImagen) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return AlertDialog(
            elevation: 5,
            title: Center(
                child: Text(
              titulo,
              style: TextStyle(fontSize: 18),
            )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(rutaImagen),
                SizedBox(
                  height: 20,
                ),
                Text(mensaje),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ok'))
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Localización de pistas deportivas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: zoom,
          minZoom: 5.0,
          maxZoom: 19.0,
          zoom: 12,
        ),
        nonRotatedChildren: [
          TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              additionalOptions: const {
                'accessToken': MAPBOX_ACCESS_TOKEN,
                'id': 'mapbox/streets-v12'
              }),
          MarkerLayer(
            markers: [
              Marker(
                  point: padelMirambel,
                  builder: (context) {
                    return Container(
                      child: IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          Platform.isAndroid
                              ? mostrarAlertaAndroid(
                                  context,
                                  "Padel Mirambel",
                                  textoPadel,
                                  rutaImagenes + "padelmirambel.jpg",
                                )
                              : mostrarAlertaIOS(
                                  context,
                                  "Padel Mirambel",
                                  textoPadel,
                                  rutaImagenes + "padelmirambel.jpg",
                                );
                        },
                        iconSize: 20,
                        color: Colors.red,
                      ),
                    );
                  }),
              Marker(
                  point: padelIglesuela,
                  builder: (context) {
                    return Container(
                      child: IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          Platform.isAndroid
                              ? mostrarAlertaAndroid(
                                  context,
                                  "Padel Iglesuela del Cid",
                                  textoPadel,
                                  rutaImagenes + "pistaiglesuela.jpg",
                                )
                              : mostrarAlertaIOS(
                                  context,
                                  "Padel Iglesuela del Cid",
                                  textoPadel,
                                  rutaImagenes + "pistaiglesuela.jpg",
                                );
                        },
                        iconSize: 20,
                        color: Colors.red,
                      ),
                    );
                  }),
              Marker(
                  point: poliCantavieja,
                  builder: (context) {
                    return Container(
                      child: IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          Platform.isAndroid
                              ? mostrarAlertaAndroid(
                                  context,
                                  "Polideportivo Cantavieja",
                                  textoPoli,
                                  rutaImagenes + "polideportivocantavieja.jpg",
                                )
                              : mostrarAlertaIOS(
                                  context,
                                  "Polideportivo Cantavieja",
                                  textoPoli,
                                  rutaImagenes + "polideportivocantavieja.jpg",
                                );
                        },
                        iconSize: 20,
                        color: Colors.red,
                      ),
                    );
                  }),
              Marker(
                  point: poliIglesuela,
                  builder: (context) {
                    return Container(
                      child: IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          Platform.isAndroid
                              ? mostrarAlertaAndroid(
                                  context,
                                  "Polideportivo Iglesuela del Cid",
                                  textoPoli,
                                  rutaImagenes + "polideportivoiglesuela.jpg",
                                )
                              : mostrarAlertaIOS(
                                  context,
                                  "Polideportivo Iglesuela del Cid",
                                  textoPoli,
                                  rutaImagenes + "polideportivoiglesuela.jpg",
                                );
                        },
                        iconSize: 20,
                        color: Colors.red,
                      ),
                    );
                  }),
              Marker(
                  point: tenisCantavieja,
                  builder: (context) {
                    return Container(
                      child: IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          Platform.isAndroid
                              ? mostrarAlertaAndroid(
                                  context,
                                  "Pista de Tenis Cantavieja",
                                  textoPadel,
                                  rutaImagenes + "tenis2.jpg",
                                )
                              : mostrarAlertaIOS(
                                  context,
                                  "Pista de Tenis Cantavieja",
                                  textoPadel,
                                  rutaImagenes + "tenis2.jpg",
                                );
                        },
                        iconSize: 20,
                        color: Colors.red,
                      ),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
