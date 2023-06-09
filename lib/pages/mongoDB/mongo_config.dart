import 'package:mongo_dart/mongo_dart.dart';

class MongoDBConnection {
  var _db;

  Future<void> openConnection() async {
    try {
      _db = Db('mongodb://192.168.1.134:27017/rural_sport');
      await _db.open();
      print('Conexión exitosa a la base de datos MongoDB');
    } catch (e) {
      print('Error al conectar a la base de datos MongoDB: $e');
    }
  }

  Future<void> closeConnection() async {
    if (_db != null) {
      await _db.close();
      print('Conexión cerrada a la base de datos MongoDB');
    }
  }

  // Aquí puedes definir tus métodos para realizar operaciones en la base de datos
}

void main() async {
  final connection = MongoDBConnection();
  await connection.openConnection();

  // Aquí puedes realizar tus operaciones en la base de datos
  print('Conectado a base de datos');

  await connection.closeConnection();
}
