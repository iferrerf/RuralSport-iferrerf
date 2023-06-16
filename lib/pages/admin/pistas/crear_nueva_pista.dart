import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../models/pista.dart';
import '../../../widgetsPersonalizados/ImagenesSelec_miniatura.dart';

class CreatePistaPage extends StatefulWidget {
  @override
  _CreatePistaPageState createState() => _CreatePistaPageState();
}

class _CreatePistaPageState extends State<CreatePistaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _lugarController = TextEditingController();
  final TextEditingController _horarioController = TextEditingController();
  String? _temporadaValue;
  final TextEditingController _anoConstruccionController =
      TextEditingController();
  String? _estadoValue;
  final TextEditingController _descripcionController = TextEditingController();
  final List<String> _images = [];

  final List<String> opcionesTemporada = [
    'Todo el año',
    'Solo invierno',
    'De junio a septiembre'
  ];

  final List<String> opcionesEstado = [
    'Muy bueno',
    'Bueno',
    'Desgastado',
    'Poco cuidado'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Pista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa un nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lugarController,
                  decoration: InputDecoration(labelText: 'Municipio'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa un lugar';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _horarioController,
                  decoration: InputDecoration(labelText: 'Horario'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa un horario';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _temporadaValue,
                  onChanged: (String? value) {
                    setState(() {
                      _temporadaValue = value!;
                    });
                  },
                  items: opcionesTemporada.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Temporada',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecciona una temporada';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _anoConstruccionController,
                  decoration: InputDecoration(labelText: 'Año Construcción'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa el año de construcción';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _estadoValue,
                  onChanged: (String? value) {
                    setState(() {
                      _estadoValue = value!;
                    });
                  },
                  items: opcionesEstado.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Estado',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecciona un estado';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa una descripción';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _alertDialog_image,
                  child: Text('Seleccionar Imagen'),
                ),
                SizedBox(height: 16),
                ImagenesSelec_miniatura(images: _images, setState: setState),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate() && _images.isNotEmpty) {
            _createPista();
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }

// Metodo que llama al endpoint para añadir la pista creada en base de datos
  void _createPista() async {
    if (_formKey.currentState!.validate()) {
      final nuevaPista = Pista(
        nombre: _nombreController.text,
        localidad: _lugarController.text,
        anoConstruccion: _anoConstruccionController.text,
        horario: _horarioController.text,
        temporada: _temporadaValue!,
        estado: _estadoValue!,
        descripcion: _descripcionController.text,
        images: _images,
      );

      print(nuevaPista.toJsonCreate());

      final response = await http.post(
        Uri.parse('https://rural-sport-bknd.vercel.app/api/pistas'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(nuevaPista.toJsonCreate()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check, color: Colors.white),
                SizedBox(width: 8),
                Text('Pista creada correctamente'),
              ],
            ),
            backgroundColor: Colors.green[300],
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(10),
          ),
        );
        final nuevaPistaResponse = Pista.fromJson(jsonDecode(response.body));
        Navigator.pop(context, nuevaPistaResponse);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Error al crear una nueva pista'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

// Dialogo para agregar imagenes a la nueva pista
  void _alertDialog_image() async {
    final imageUrl = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final _imageUrlController = TextEditingController();

        return AlertDialog(
          title: Text('Agregar Imagen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'URL de la imagen',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String imageUrl = _imageUrlController.text.trim();
                if (imageUrl.isNotEmpty) {
                  Navigator.of(context).pop(imageUrl);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );

    if (imageUrl != null) {
      setState(() {
        _images.add(imageUrl);
      });
    }
  }
}
