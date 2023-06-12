import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  final TextEditingController _anoConstruccionController =
      TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  List<dynamic> _images = [];

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

  // String selectedTemporada = "";
  // String selectedEstado = "";

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.pistaInfo['nombre'] ?? '';
    _lugarController.text = widget.pistaInfo['lugar'] ?? '';
    _horarioController.text = widget.pistaInfo['horario'] ?? '';
    _temporadaController.text = widget.pistaInfo['temporada'] ?? '';
    _images = List<dynamic>.from(widget.pistaInfo['images'] ?? []);
    _anoConstruccionController.text = widget.pistaInfo['añoConstruccion'] ?? '';
    _estadoController.text = widget.pistaInfo['estado'] ?? '';
    // selectedEstado = _estadoController.text;
    // selectedTemporada = _temporadaController.text;
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
            _swiper(_images),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                              _buildInfoRow(
                                'Municipio:',
                                _lugarController.text,
                                Colors.black,
                                Colors.green,
                              ),
                              _buildInfoRow(
                                'Temporada:',
                                _temporadaController.text,
                                Colors.black,
                                Colors.green,
                              ),
                              _buildInfoRow(
                                'Horario:',
                                _horarioController.text,
                                Colors.black,
                                Colors.green,
                              ),
                              _buildInfoRow(
                                'Año Construcción:',
                                _anoConstruccionController.text,
                                Colors.black,
                                Colors.green,
                              ),
                              _buildInfoRow(
                                'Estado:',
                                _estadoController.text,
                                Colors.black,
                                Colors.green,
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
              padding: EdgeInsets.all(20),
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

  Widget _buildInfoRow(
    String title,
    String data,
    Color titleColor,
    Color dataColor,
  ) {
    // if (title == 'Temporada') {
    //   data = selectedTemporada.isNotEmpty ? selectedTemporada : data;
    // } else if (title == 'Estado') {
    //   data = selectedEstado.isNotEmpty ? selectedEstado : data;
    // }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              data,
              style: TextStyle(
                fontSize: 16,
                color: dataColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _swiper(List<dynamic> images) {
    final copiedImages =
        List<dynamic>.from(images); // Hacer una copia de la lista

    return Container(
      height: 250.0,
      margin: EdgeInsets.only(top: 10),
      color: Colors.white70,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          final image = copiedImages[index]; // Utilizar la lista copiada
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: copiedImages.length == 0 ? 1 : copiedImages.length,
        pagination: SwiperPagination(),
        control: SwiperControl(),
        viewportFraction: 0.95,
        scale: 0.7,
      ),
    );
  }

  Future<void> _showEditDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return StatefulBuilder(
        //   builder: (BuildContext context, StateSetter setState) {
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
                _buildSelectedImages(setState),
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
                  Navigator.of(context).pop();
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
    //   },
    // );
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

  Widget _buildSelectedImages(StateSetter setState) {
    final reversedImages = _images.reversed.toList(); // Revertir la lista

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imágenes Seleccionadas:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var index = 0; index < reversedImages.length; index++)
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(reversedImages[index]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _images.removeAt(_images.length -
                                1 -
                                index); // Eliminar la imagen de la lista
                          });
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
