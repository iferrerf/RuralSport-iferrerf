import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_final_iferrerf/models/reserva.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';

const COLLECTION_NAME = 'reservas';

FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;
String? email = user?.email.toString();

final List<String> dias = [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo'
];

final List<String> horas = [
  '8:00',
  '9:00',
  '10:00',
  '11:00',
  '12:00',
  '13:00',
  '14:00',
  '15:00',
  '16:00',
  '17:00',
  '18:00',
  '19:00',
  '20:00',
  '21:00'
];

final List<String> tiempo = ['1 hora', '1 hora y 30 min'];

class ReservasPageAdmin extends StatefulWidget {
  const ReservasPageAdmin({Key? key}) : super(key: key);

  @override
  State<ReservasPageAdmin> createState() => _ReservasPageAdminState();
}

class _ReservasPageAdminState extends State<ReservasPageAdmin> {
  List<Reserva> listaReservas = [];

  @override
  void initState() {
    super.initState();

    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
    email = user?.email.toString();

    FirebaseFirestore.instance.collection(COLLECTION_NAME).snapshots().listen(
      (reservas) {
        mapReservas(reservas);
      },
    );

    diaSelect = dias[0];
    horaSelect = horas[0];
    tiempoSelect = tiempo[0];
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? diaSelect;
  String? horaSelect;
  String? tiempoSelect;

  // Consultamos los registros de la coleccion de Firebase Firestore
  void fetchReservas() async {
    var listaReservas =
        await FirebaseFirestore.instance.collection(COLLECTION_NAME).get();
    mapReservas(listaReservas);
  }

  void mapReservas(QuerySnapshot<Map<String, dynamic>> _listaReserva) {
    var _list = _listaReserva.docs
        .map((reserva) => Reserva(
              id: reserva.id,
              usuario: reserva['usuario'],
              dia: reserva['dia'],
              hora: reserva['hora'],
              tiempo: reserva['tiempo'],
            ))
        .toList();

    setState(() {
      listaReservas = _list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Padding(
          padding: const EdgeInsets.all(30),
          child: const Text(
            'Reservas de pistas',
            style: TextStyle(color: Colors.white),
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
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: listaReservas.length,
        itemBuilder: (context, index) {
          return Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    eliminarReserva(listaReservas[index].id);
                    // Muestro un Snackbar diciendo que el producto se ha eliminado
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.redAccent,
                        content:
                            Text('Se ha eliminado la reserva correctamente')));
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              onTap: () {
                showItemDialogUpdate(
                    listaReservas[index].id,
                    listaReservas[index].usuario,
                    listaReservas[index].dia,
                    listaReservas[index].hora,
                    listaReservas[index].tiempo);
              },
              title: Text(listaReservas[index].dia),
              subtitle: Text(listaReservas[index].hora),
            ),
          );
        },
      ),
    );
  }

  void showItemDialog() {
    var usuarioController = TextEditingController(text: email);

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
                        child: Text('Añadir Reserva',
                            style: TextStyle(fontSize: 20)))
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Email del usuario'),
                  controller: usuarioController,
                ),
                DropdownButtonFormField(
                    decoration:
                        const InputDecoration(labelText: "Dia de la reserva"),
                    items: dias.map((e) {
                      return DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        diaSelect = val!;
                      });
                    }),
                DropdownButtonFormField(
                    decoration:
                        const InputDecoration(labelText: "Hora de inicio"),
                    items: horas.map((e) {
                      return DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        horaSelect = val!;
                      });
                    }),
                DropdownButtonFormField(
                    decoration:
                        const InputDecoration(labelText: "Tiempo de uso"),
                    items: tiempo.map((e) {
                      return DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        tiempoSelect = val!;
                      });
                    }),
                TextButton(
                    onPressed: () {
                      var usuario = usuarioController.text.trim();
                      var dia = diaSelect;
                      var hora = horaSelect;
                      var tiempo = tiempoSelect;
                      addReserva(usuario, dia!, hora!, tiempo!);
                      Navigator.pop(context);
                    },
                    child:
                        const Text('Añadir', style: TextStyle(fontSize: 18))),
              ],
            ),
          ),
        );
      },
    );
  }

  void showItemDialogUpdate(
      String idDoc, String? usuario, String dia, String hora, String tiempo) {
    var usuarioController = TextEditingController(text: usuario);
    var diaController = TextEditingController(text: dia);
    var horaController = TextEditingController(text: hora);
    var tiempoController = TextEditingController(text: tiempo);

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
                            style: TextStyle(fontSize: 20)))
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(labelText: 'Usuario'),
                  controller: usuarioController,
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Dia de la reserva'),
                  controller: diaController,
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Hora de inicio'),
                  controller: horaController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Tiempo de uso'),
                  controller: tiempoController,
                ),
                TextButton(
                    onPressed: () {
                      var usuario = usuarioController.text.trim();
                      var dia = diaController.text.trim();
                      var hora = horaController.text.trim();
                      var tiempo = tiempoController.text.trim();

                      actualizarReserva(idDoc, usuario, dia, hora, tiempo);
                      Navigator.pop(context);
                    },
                    child: const Text('Actualizar',
                        style: TextStyle(fontSize: 18))),
              ],
            ),
          ),
        );
      },
    );
  }

  void addReserva(String usuario, String dia, String hora, String tiempo) {
    Reserva reserva = Reserva(
        id: "id", usuario: usuario, dia: dia, hora: hora, tiempo: tiempo);

    FirebaseFirestore.instance
        .collection(COLLECTION_NAME)
        .add(reserva.toJson());
  }

  void eliminarReserva(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection(COLLECTION_NAME)
          .doc(id)
          .delete();
    } catch (e) {
      print('Error al eliminar la reserva: $e');
    }
  }

  CollectionReference users =
      FirebaseFirestore.instance.collection(COLLECTION_NAME);

  Future<void> actualizarReserva(
      String idDoc, String usuario, String dia, String hora, String tiempo) {
    return users
        .doc(idDoc)
        .update(
            {'usuario': usuario, 'dia': dia, 'hora': hora, 'tiempo': tiempo})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
