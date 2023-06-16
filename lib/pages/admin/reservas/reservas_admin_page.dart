import 'package:flutter/material.dart';
import 'package:flutter_app_final_iferrerf/theme/app_theme.dart';

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_app_final_iferrerf/models/pista.dart';
import 'package:flutter_app_final_iferrerf/models/reserva.dart';

const COLLECTION_NAME = 'reservas';

class ReservasAdminPage extends StatefulWidget {
  const ReservasAdminPage({Key? key}) : super(key: key);

  @override
  State<ReservasAdminPage> createState() => _ReservasAdminPageState();
}

class _ReservasAdminPageState extends State<ReservasAdminPage> {
  List<Reserva> listaReservas = [];
  List<Pista> pistas = [];
  Pista? pistaSeleccionada;

  String? diaSelect;

  late DateTime selectedDate;
  late TimeOfDay selectedTimeStart;
  late TimeOfDay selectedTimeEnd;

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
    selectedTimeStart = TimeOfDay.now();
    selectedTimeEnd = selectedTimeStart;

    obtenerPistas();
    fetchReservas();

    FirebaseFirestore.instance.collection(COLLECTION_NAME).snapshots().listen(
      (reservas) {
        mapReservas(reservas);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(30),
          child: Align(
            alignment: Alignment.center,
            child: const Text(
              'Reservas de pistas',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              //Abro el Dialogo para introducir los datos
              showItemDialog();
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: listaReservas.length,
        itemBuilder: (context, index) {
          // Determinar el color de fondo de la tarjeta
          Color? cardColor = index % 2 == 0
              ? Colors.white
              : AppTheme().adminTheme.primaryColor;

          Color? textColor =
              index % 2 == 0 ? Colors.lightGreen[800] : Colors.grey[200];

          return Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    try {
                      eliminarReserva(listaReservas[index].id!);
                      // Muestro un Snackbar diciendo que el producto se ha eliminado
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content:
                              Text('Se ha eliminado la reserva correctamente'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Error al eliminar la reserva '),
                        ),
                      );
                    }
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                onTap: () {
                  // Muestro el dialogo de actualizar reserva con la info precargada
                  showItemDialogUpdate(
                    listaReservas[index].id!,
                    listaReservas[index].usuario,
                    listaReservas[index].dia,
                    listaReservas[index].horaInicio,
                  );
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      '${listaReservas[index].pista!.nombre}, ${listaReservas[index].pista!.localidad}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.red),
                        SizedBox(width: 4),
                        Text(
                          listaReservas[index].dia,
                          style: TextStyle(fontSize: 14, color: textColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 16, color: Colors.lightBlue),
                        SizedBox(width: 4),
                        Text(
                          '${listaReservas[index].horaInicio} - ${listaReservas[index].horaFin}',
                          style: TextStyle(fontSize: 14, color: textColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(Icons.person,
                              size: 16, color: Colors.blueGrey[200]),
                          SizedBox(width: 4),
                          Text(
                            '${listaReservas[index].usuario}',
                            style: TextStyle(fontSize: 14, color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// -------------FECHAS--------------
// Funcion que selecciona una fecha con un calendario y la guarda
  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
    return getDiaSemana(selectedDate) +
        ' ' +
        DateFormat('yyyy-MM-dd').format(selectedDate);
  }

// Funcion que permite seleccionar una hora mediante un dialogo de reloj y lo guarda
  Future<void> _selectTimeStart(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTimeStart,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTimeStart = pickedTime;
        selectedTimeEnd = _calculateTimeEnd(pickedTime);
      });
    }
  }

// Calculamos la fecha final de la reserva en funcion de la fecha de entrada
  TimeOfDay _calculateTimeEnd(TimeOfDay selectTime) {
    final minutesPerHour = 60;
    final minutesToAdd = 90;

    final totalMinutes =
        selectTime.hour * minutesPerHour + selectTime.minute + minutesToAdd;
    final hour = totalMinutes ~/ minutesPerHour;
    final minute = totalMinutes % minutesPerHour;

    final timeEnd = TimeOfDay(hour: hour, minute: minute);

    return timeEnd;
  }

// Convertmos un string en un TimeOfDay
  TimeOfDay _convertStringToTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

// Funcion que devuelve el dia de la semana en texto
  String getDiaSemana(DateTime date) {
    final diasSemana = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado'
          'Domingo',
    ];
    final diaSemana = date.weekday;
    return diasSemana[diaSemana - 1];
  }

// Funcion para transformar un TimeOfDay en string
  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

// ---------------OBTENCIÓN DE DATOS------------------
// Metodo que mapea la lista de reservas
  void mapReservas(QuerySnapshot<Map<String, dynamic>> _listaReserva) {
    var _list = _listaReserva.docs
        .map((reserva) => Reserva(
              id: reserva.id,
              usuario: reserva['usuario'],
              dia: reserva['dia'],
              horaInicio: reserva['horaInicio'],
              horaFin: reserva['horaFin'],
              pista: Pista.fromJson(reserva['pista']),
            ))
        .toList();

    setState(() {
      listaReservas = _list;
    });
  }

// Metodo que hace una peticion a base de datos para obtener las pistas
  Future<void> obtenerPistas() async {
    try {
      final response = await http
          .get(Uri.parse('https://rural-sport-bknd.vercel.app/api/pistas'));

      if (response.statusCode == 200) {
        final List<dynamic> datos = jsonDecode(response.body);
        final List<Pista> listaPistas =
            datos.map((item) => Pista.fromJson(item)).toList();

        setState(() {
          pistas = listaPistas;
        });
      } else {
        print(
            'Error al obtener las pistas. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en la solicitud HTTP: $error');
    }
  }

// Consultamos los registros de la colección de Firebase Firestore
  void fetchReservas() async {
    var listaReservas =
        await FirebaseFirestore.instance.collection(COLLECTION_NAME).get();
    mapReservas(listaReservas);
  }

// -------------DIÁLOGOS DE FORMULARIOS----------------
// Dialogo de añadir nueva pista
  void showItemDialog() {
    var usuarioController = TextEditingController(text: "@gmail.com");
    ThemeData adminColor = AppTheme().adminTheme;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      SizedBox(
                        width: 70,
                        child: Icon(Icons.note_add_outlined),
                      ),
                      SizedBox(
                        child: Text(
                          'Añadir Reserva',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email del usuario'),
                    controller: usuarioController,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<Pista>(
                    decoration: InputDecoration(labelText: 'Pista'),
                    value: pistaSeleccionada,
                    items: pistas.map((pista) {
                      return DropdownMenuItem<Pista>(
                        value: pista,
                        child: Text(
                          pista.nombre + " - " + pista.localidad,
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        pistaSeleccionada = val;
                      });
                    },
                    isExpanded: true,
                    menuMaxHeight: 200,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Día de la reserva:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          _selectDate(context).then((selectedDate) {
                            setState(() {
                              diaSelect = selectedDate;
                            });
                          });
                        },
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(16),
                          ),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              adminColor.primaryColor),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.calendar_today),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Hora de inicio:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          _selectTimeStart(context);
                        },
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(16),
                          ),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              adminColor.primaryColor),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.timer_outlined),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        print(diaSelect);
                        if (diaSelect != null &&
                            selectedTimeEnd != selectedTimeStart) {
                          var usuario = usuarioController.text.trim();
                          var dia = diaSelect;
                          var horaInicio =
                              '${selectedTimeStart.hour.toString().padLeft(2, '0')}:${selectedTimeStart.minute.toString().padLeft(2, '0')}';
                          var horaFin =
                              '${selectedTimeEnd.hour.toString().padLeft(2, '0')}:${selectedTimeEnd.minute.toString().padLeft(2, '0')}';
                          addReserva(usuario, dia!, horaInicio, horaFin);
                          Navigator.of(context).maybePop();
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Debes seleccionar una pista, una fecha y una hora.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Aceptar'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(16),
                        ),
                      ),
                      child:
                          const Text('Añadir', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Dialogo de actualizar reserva
  void showItemDialogUpdate(
    String idDoc,
    String? usuario,
    String dia,
    String horaInicio,
  ) {
    var usuarioController = TextEditingController(text: usuario);
    var diaController = TextEditingController(text: dia);
    var horaInicioController = TextEditingController(text: horaInicio);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    SizedBox(
                        width: 70, child: Icon(Icons.data_object_outlined)),
                    SizedBox(
                        child: Text('Actualizar Reserva',
                            style: TextStyle(fontSize: 20))),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(labelText: 'Usuario'),
                  controller: usuarioController,
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Día de la reserva'),
                  controller: diaController,
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Hora de inicio'),
                  controller: horaInicioController,
                ),
                TextButton(
                  onPressed: () {
                    var usuario = usuarioController.text.trim();
                    var dia = diaController.text.trim();
                    var horaInicio = horaInicioController.text.trim();
                    var hora_aux = _convertStringToTimeOfDay(horaInicio);
                    var horaFin = _calculateTimeEnd(hora_aux);
                    actualizarReserva(idDoc, usuario, dia, horaInicio,
                        formatTimeOfDay(horaFin));
                    Navigator.pop(context);
                  },
                  child:
                      const Text('Actualizar', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// ----------ACCIONES DE LAS RESERVAS---------------
// Metodo para añadir reserva a Firebase
  void addReserva(
      String usuario, String dia, String horaInicio, String horaFin) {
    if (pistaSeleccionada != null) {
      Reserva reserva = Reserva(
        usuario: usuario,
        dia: dia,
        horaInicio: horaInicio,
        horaFin: horaFin,
        pista: pistaSeleccionada!,
      );

      FirebaseFirestore.instance
          .collection(COLLECTION_NAME)
          .add(reserva.toJson());
    }
  }

// Metodo para eliminar la reserva por el idDoc de la reserva en Firebase
  void eliminarReserva(String idDoc) {
    FirebaseFirestore.instance.collection(COLLECTION_NAME).doc(idDoc).delete();
  }

  CollectionReference users =
      FirebaseFirestore.instance.collection(COLLECTION_NAME);

// Metodo para actualizar la reserva
  Future<void> actualizarReserva(String idDoc, String usuario, String dia,
      String horaInicio, String horaFin) {
    return users
        .doc(idDoc)
        .update({
          'usuario': usuario,
          'dia': dia,
          'horaInicio': horaInicio,
          'horaFin': horaFin,
        })
        .then((value) => print('Reserva actualizada correctamente'))
        .catchError((error) => print('Fallo al actualizar la reserva: $error'));
  }
}
