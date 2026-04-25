import 'package:mysql1/mysql1.dart';

abstract class Database {
  static final String _host = "localhost";
  static final int _port = 3306;
  static final String _user = "root";
  static final String _dbName = "proyectoDB";

  //creacion de la base de datos cuando la aplicacion se inicia por primera vez
  static instalacionDB() async {
    var settings = ConnectionSettings(host: _host, port: _port, user: _user);
    var conn = await MySqlConnection.connect(settings);
    try {
      await _crearDB(conn);
      await _crearTablaUsuarios(conn);
      await _crearTablaPersonajes(conn);
      await _crearTablaUsuariosPersonajes(conn);
      //await _crearUsuario(conn);
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  //metodo que crea la base de datos
  static _crearDB(conn) async {
    await conn.query('CREATE DATABASE IF NOT EXISTS $_dbName');
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

  //metodo que permite crear la tabla de Personajes
  static _crearTablaPersonajes(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS personajes(
    idPersonaje INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombrePersonaje VARCHAR(50) NOT NULL,
    fuerza INT NOT NULL,
    destreza INT NOT NULL,
    constitucion INT NOT NULL,
    inteligencia INT NOT NULL,
    sabiduria INT NOT NULL,
    carisma INT NOT NULL,
    clase VARCHAR(50) NOT NULL,
    experiencia INT NOT NULL,
    raza VARCHAR(50) NOT NULL,
    puntosVida INT NOT NULL,
    equipoInicial TEXT NOT NULL,
    trasfondo VARCHAR(50) NOT NULL,
    hechizos TEXT NOT NULL,
    alineamiento VARCHAR(50) NOT NULL,
    puntosGolpe INT NOT NULL,
    iniciativa INT NOT NULL,
    armadura INT NOT NULL,
    velocidad TEXT NOT NULL,
    idioma VARCHAR(50) NOT NULL,
    nivel INT NOT NULL
)''');
    //print('Tabla de personajes creada');
  }

  //metodo que permite la conexion a la base de datos fuera de la clase.
  static Future<MySqlConnection> conexionDB() async {
    var settings = ConnectionSettings(
      host: _host,
      port: _port,
      user: _user,
      db: _dbName,
    );
    return await MySqlConnection.connect(settings);
  }

  //metodo que permite crear la tabla usuariospersonajes
  static _crearTablaUsuariosPersonajes(conn) async {
    await conn.query("""CREATE TABLE IF NOT EXISTS usuariospersonajes (
    iduserpersonaje INT PRIMARY KEY AUTO_INCREMENT,
    iduser INT NOT NULL,
    idpersonaje INT NOT NULL
    )""");
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
