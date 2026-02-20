import 'package:mysql1/mysql1.dart';

abstract class Database {
  static final String _host = "localhost";
  static final int _port = 3306;
  static final String _user = "root";

  //creacion de la base de datos cuando la aplicacion se inicia por primera vez
  static instalacionDB() async {
    var settings = ConnectionSettings(host: _host, port: _port, user: _user);
    var conn = await MySqlConnection.connect(settings);
    try {
      await _crearDB(conn);
      await _crearTablaUsuarios(conn);
      //await _crearUsuario(conn);
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  //metodo que crea la base de datos
  static _crearDB(conn) async {
    await conn.query('CREATE DATABASE IF NOT EXISTS proyectoDB');
    await conn.query('USE proyectoDB');
    //print('Base de datos creada');
  }

  //metodo que crea la tabla usuarios
  static _crearTablaUsuarios(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS usuarios(
    idUsuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombreReal VARCHAR(50) NOT NULL,
    nombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    contrasenna VARCHAR(50) NOT NULL
    )''');
    //print("Tabla de usuarios creada");
  }

  //metodo que permite la conexion a la base de datos fuera de la clase.
  static Future<MySqlConnection> conexionDB() async {
    var settings = ConnectionSettings(
      host: _host,
      port: _port,
      user: _user,
      db: 'proyectoDB',
    );
    return await MySqlConnection.connect(settings);
  }

  //metodo que inserta un usuario en la base de datos(PRUEBA)
  // static _crearUsuario(conn) async {
  //   await conn.query(
  //     'INSERT INTO usuarios(contrasenna,idUsuario,nombreReal,nombreUsuario) values (?,?,?,?)',
  //     ["Clave1234567", 1, "Ivan Garcia", "ivangargalan"],
  //   );
  //   //print("Usuario creado");
  //}
}
