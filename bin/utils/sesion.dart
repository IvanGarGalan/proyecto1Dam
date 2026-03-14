import 'utils.dart';
import '../entities/entities.dart';
import 'package:mysql1/mysql1.dart';

abstract class Sesion {
  static Usuario? usuario;

  //metodo para iniciar sesion en la aplicacion
  static Future<bool> iniciarSesion(Map<String, String> datos) async {
    //metodo para poder iniciar sesion
    MySqlConnection conn = await Database.conexionDB();
    var inicio = await conn.query(
      "SELECT * FROM usuarios WHERE nombreUsuario = ?",
      [datos["usuario"]],
    );
    if (inicio.isEmpty || inicio.first[3] != datos['contra']) {
      await conn
          .close(); //si se encuentra un resultado,es incorrecto y devuelve falso
      return false;
    }
    await conn.close();
    //si es true, se crea la sesion con los datos de la sesion
    Sesion.usuario = Usuario(
      inicio.first[0],
      inicio.first[1],
      inicio.first[2],
      inicio.first[3],
    );
    return true;
  }
}
