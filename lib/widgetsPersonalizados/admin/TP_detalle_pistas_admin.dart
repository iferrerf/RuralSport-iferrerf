import 'package:flutter/material.dart';
import 'package:flutter_app_final_iferrerf/models/pista.dart';
import 'package:flutter_app_final_iferrerf/widgetsPersonalizados/Carrusel_images.dart';
import 'package:flutter_app_final_iferrerf/widgetsPersonalizados/ImagenesSelec_miniatura.dart';
import 'package:flutter_app_final_iferrerf/widgetsPersonalizados/infoCard_detalle_pistas.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class TP_detalle_pistas_admin extends StatefulWidget {
  TP_detalle_pistas_admin({
    Key? key,
    required this.pistaInfo,
  }) : super(key: key);

  final Map<String, dynamic> pistaInfo;

  @override
  State<TP_detalle_pistas_admin> createState() =>
      _TP_detalle_pistas_adminState();
}

class _TP_detalle_pistas_adminState extends State<TP_detalle_pistas_admin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _lugarController = TextEditingController();
  final TextEditingController _horarioController = TextEditingController();
  final TextEditingController _temporadaController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _anoConstruccionController =
      TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  List<dynamic> _images = [];

  String _id = "";

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
  void initState() {
    super.initState();
    _id = widget.pistaInfo['_id'];
    _nombreController.text = widget.pistaInfo['nombre'] ?? '';
    _lugarController.text = widget.pistaInfo['lugar'] ?? '';
    _horarioController.text = widget.pistaInfo['horario'] ?? '';
    _temporadaController.text = widget.pistaInfo['temporada'] ?? '';
    _images = List<dynamic>.from(widget.pistaInfo['images'] ?? []);
    _anoConstruccionController.text = widget.pistaInfo['añoConstruccion'] ?? '';
    _estadoController.text = widget.pistaInfo['estado'] ?? '';
    _descripcionController.text = widget.pistaInfo['descripcion'] ?? '';
  }

  Future<void> sendPista(Pista pista) async {
    final response = await http.put(
      Uri.parse('https://rural-sport-bknd.vercel.app/api/pistas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pista.toJson()),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check, color: Colors.white),
              SizedBox(width: 8),
              Text('Pista actualizada correctamente'),
            ],
          ),
          backgroundColor: Colors.green[300],
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(10),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('Error al actualizar la pista'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _nombreController.text,
            style: TextStyle(color: Colors.white),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Carrusel_images(images: _images),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, right: 20, bottom: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                _nombreController.text,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(height: 16),
                              InfoCard_detalle_pistas(
                                  title: 'Municipio:',
                                  data: _lugarController.text,
                                  titleColor: Colors.black,
                                  dataColor: Colors.green),
                              InfoCard_detalle_pistas(
                                  title: 'Temporada:',
                                  data: _temporadaController.text,
                                  titleColor: Colors.black,
                                  dataColor: Colors.green),
                              InfoCard_detalle_pistas(
                                  title: 'Horario:',
                                  data: _horarioController.text,
                                  titleColor: Colors.black,
                                  dataColor: Colors.green),
                              InfoCard_detalle_pistas(
                                  title: 'Año Construcción:',
                                  data: _anoConstruccionController.text,
                                  titleColor: Colors.black,
                                  dataColor: Colors.green),
                              InfoCard_detalle_pistas(
                                  title: 'Estado:',
                                  data: _estadoController.text,
                                  titleColor: Colors.black,
                                  dataColor: Colors.green),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Descripción:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        _descripcionController.text,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  _showEditDialog();
                },
                icon: Icon(Icons.assignment_add),
                label: Text('Modificar datos'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Datos'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
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
                  decoration: InputDecoration(labelText: 'Lugar'),
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
                  value: _temporadaController.text,
                  onChanged: (String? value) {
                    setState(() {
                      _temporadaController.text = value!;
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
                  value: _estadoController.text,
                  onChanged: (String? value) {
                    _estadoController.text = value!;
                    setState(() {});
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
                  onPressed: () {
                    _pickImage().then((imageUrl) {
                      if (imageUrl != null) {
                        setState(() {
                          _images.add(imageUrl);
                        });
                      }
                    });
                  },
                  child: Text('Seleccionar Imagen'),
                ),
                SizedBox(height: 16),
                ImagenesSelec_miniatura(images: _images, setState: setState),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nombreController.text = widget.pistaInfo['nombre'] ?? '';
                _lugarController.text = widget.pistaInfo['lugar'] ?? '';
                _horarioController.text = widget.pistaInfo['horario'] ?? '';
                _temporadaController.text = widget.pistaInfo['temporada'] ?? '';
                _anoConstruccionController.text =
                    widget.pistaInfo['añoConstruccion'] ?? '';
                _estadoController.text = widget.pistaInfo['estado'] ?? '';
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            SizedBox(
              width: 100,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Pista pistaActualizada = Pista(
                    id: _id,
                    nombre: _nombreController.text,
                    localidad: _lugarController.text,
                    horario: _horarioController.text,
                    temporada: _temporadaController.text,
                    anoConstruccion: _anoConstruccionController.text,
                    estado: _estadoController.text,
                    images: _images,
                    descripcion: _descripcionController.text,
                  );
                  print(pistaActualizada);
                  sendPista(pistaActualizada);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _pickImage() async {
    final TextEditingController _imageUrlController = TextEditingController();

    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
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
  }
}
