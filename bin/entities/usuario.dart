import '../utils/utils.dart';

abstract class Usuario {
  String? _nombreReal;
  String? _nombreUsuario;
  String? _contrasenna;

  //metodo para iniciar sesion en la aplicacion
  static Future<bool> iniciarSesion(Map<String, String> datos) async {
    bool inicioCorrecto = false;
    var conn;
    try {
      //conexion a la base de datos que busca el usuario
      conn = await Database.conexionDB();
      var inicio = await conn.query(
        'SELECT * FROM usuarios where nombreUsuario = ? AND contrasenna = ?',
        [datos['usuario'], datos['contra']],
      );
      if (inicio.isNotEmpty) {
        inicioCorrecto = true; //si encuentra el usuario,devuelve true
      }
    } catch (e) {
      print(e);
    } finally {
      await conn.close;
    }
    return inicioCorrecto;
  }
}
