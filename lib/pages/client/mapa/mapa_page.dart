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
final padelIglesuela = LatLng(40.482076, -0.315651);
final tenisCantavieja = LatLng(40.523244, -0.404215);
final zoom = LatLng(40.547240, -0.348118);

class MapPage extends StatelessWidget {
  MapPage({super.key});

  final String textoPoliCtvj = "C.Garcia Valiño, 44140 Cantavieja, Teruel";
  final String textoTenisCtvj = "Las piscinas, 44140 Cantavieja, Teruel";
  final String textoPoliIglesuela =
      "C.Fuentenueva, 44142 Iglesuela del Cid, Teruel";
  final String textoPadelIglesuela =
      "C.Calvario, 44142 Iglesuela del Cid, Teruel";
  final String textoPadelMirambel =
      "Alto las piscinas, 44141, Mirambel, Teruel";

  void mostrarAlertaIOS(BuildContext context, String titulo, String mensaje) {
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: ((context) {
        return CupertinoAlertDialog(
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on_outlined),
                Text(titulo),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
      BuildContext context, String titulo, String mensaje) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox(width: 8),
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  mensaje,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok'),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                                  textoPadelMirambel,
                                )
                              : mostrarAlertaIOS(
                                  context,
                                  "Padel Mirambel",
                                  textoPadelMirambel,
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
                                  textoPadelIglesuela,
                                )
                              : mostrarAlertaIOS(
                                  context,
                                  "Padel Iglesuela del Cid",
                                  textoPadelIglesuela,
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
                                  textoPoliCtvj,
                                )
                              : mostrarAlertaIOS(
                                  context,
                                  "Polideportivo Cantavieja",
                                  textoPoliCtvj,
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
                                  textoPoliIglesuela,
                                )
                              : mostrarAlertaIOS(
                                  context,
                                  "Polideportivo Iglesuela del Cid",
                                  textoPoliIglesuela,
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
                                  textoTenisCtvj,
                                )
                              : mostrarAlertaIOS(
                                  context,
                                  "Pista de Tenis Cantavieja",
                                  textoTenisCtvj,
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
