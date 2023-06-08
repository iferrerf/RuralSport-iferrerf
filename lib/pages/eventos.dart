import 'package:flutter_app_final_iferrerf/pages/mongo_config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

import 'imports.dart';

class Event {
  String id;
  String pista;
  DateTime fechaInicio;
  DateTime fechaFin;

  Event(
      {required this.id,
      required this.pista,
      required this.fechaInicio,
      required this.fechaFin});
}

MongoDBConnection connection = MongoDBConnection();

class EventosPage extends StatefulWidget {
  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDate;
  late DateTime _selectedDate;
  late ValueNotifier<List<Event>> _selectedEvents;
  List<Event> _events = [];
  TextEditingController _pistaController = TextEditingController();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  List<String> pistas = ['Pista 1', 'Pista 2', 'Pista 3'];

  @override
  void initState() {
    super.initState();
    super.initState();
    _calendarFormat = CalendarFormat.twoWeeks;
    _focusedDate = DateTime.now();
    _selectedDate = _focusedDate;
    _selectedEvents = ValueNotifier(_getEventsForDate(_selectedDate));
  }

  List<Event> _getEventsForDate(DateTime date) {
    return _events.where((event) {
      final eventDate = event.fechaInicio;
      return eventDate.year == date.year &&
          eventDate.month == date.month &&
          eventDate.day == date.day;
    }).toList();
  }

  void _onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      _selectedDate = selectedDate;
      _focusedDate = focusedDate;
      _selectedEvents.value = _getEventsForDate(_selectedDate);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addEvent() {
    String _selectedPista = pistas.first;
    DateTime _selectedDate = DateTime.now();
    String _fi_subtitleDate = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nuevo Evento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedPista,
              items: pistas
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedPista = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Pista',
              ),
            ),
            ListTile(
              title: Text('Fecha de inicio'),
              subtitle: Text(_fi_subtitleDate),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 7)),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                    _fi_subtitleDate = pickedDate.toString().split(' ')[0];
                  });
                }
              },
            ),
            ListTile(
              title: Text('Hora de inicio'),
              subtitle: Text(_selectedStartTime.format(context)),
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedStartTime,
                );
                if (pickedTime != null && pickedTime != _selectedStartTime) {
                  setState(() {
                    _selectedStartTime = pickedTime;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Hora de finalización'),
              subtitle: Text(_selectedEndTime.format(context)),
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedEndTime,
                );
                if (pickedTime != null && pickedTime != _selectedEndTime) {
                  setState(() {
                    _selectedEndTime = pickedTime;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final event = Event(
                  id: DateTime.now().toString(),
                  pista: _selectedPista,
                  fechaInicio: DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedStartTime.hour,
                    _selectedStartTime.minute,
                  ),
                  fechaFin: DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedEndTime.hour,
                    _selectedEndTime.minute,
                  ),
                );
                _events.add(event);
                _pistaController.text = '';
              });
              Navigator.of(context).pop();
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _updateEvent(Event event) {
    _pistaController.text = event.pista;
    _selectedDate = event.fechaInicio;
    _selectedStartTime = TimeOfDay.fromDateTime(event.fechaInicio);
    _selectedEndTime = TimeOfDay.fromDateTime(event.fechaFin);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Actualizar Evento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _pistaController.text,
              items: ['Pista 1', 'Pista 2', 'Pista 3']
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  _pistaController.text = value ?? '';
                });
              },
              decoration: InputDecoration(
                labelText: 'Pista',
              ),
            ),
            ListTile(
              title: Text('Fecha de inicio'),
              subtitle: Text(_selectedDate.toString().split(' ')[0]),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Hora de inicio'),
              subtitle: Text(_selectedStartTime.format(context)),
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedStartTime,
                );
                if (pickedTime != null && pickedTime != _selectedStartTime) {
                  setState(() {
                    _selectedStartTime = pickedTime;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Hora de finalización'),
              subtitle: Text(_selectedEndTime.format(context)),
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedEndTime,
                );
                if (pickedTime != null && pickedTime != _selectedEndTime) {
                  setState(() {
                    _selectedEndTime = pickedTime;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                event.pista = _pistaController.text;
                event.fechaInicio = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDate.day,
                  _selectedStartTime.hour,
                  _selectedStartTime.minute,
                );
                event.fechaFin = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDate.day,
                  _selectedEndTime.hour,
                  _selectedEndTime.minute,
                );
                _pistaController.text = '';
              });
              Navigator.of(context).pop();
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _deleteEvent(Event event) {
    setState(() {
      _events.remove(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Eventos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addEvent,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDate,
            firstDay: DateTime(DateTime.now().year - 1),
            lastDay: DateTime(DateTime.now().year + 1),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDate,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return Slidable(
                  key: ValueKey(event.id),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _updateEvent(event);
                          // Muestro un Snackbar diciendo que el producto se ha eliminado
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                  'Se ha eliminado la reserva correctamente')));
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
                      _updateEvent(event);
                    },
                    title: Text(event.pista),
                    subtitle: Text(
                      '${event.fechaInicio.toString().split(' ')[1].substring(0, 5)} - ${event.fechaFin.toString().split(' ')[1].substring(0, 5)}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
