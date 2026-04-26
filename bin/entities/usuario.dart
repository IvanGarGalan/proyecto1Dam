import '../utils/utils.dart';
import 'package:mysql1/mysql1.dart';

class Usuario {
  int? idUsuario;
  String? nombreReal;
  String? nombreUsuario;
  String? contrasenna;

  Usuario(
    this.idUsuario,
    this.nombreReal,
    this.nombreUsuario,
    this.contrasenna,
  );

  //metodo que sirve para registrar un usuario en la base de datos,si no esta.lo registra correctamente
  static Future<bool> registro(Map<String, String> datos) async {
    MySqlConnection conn = await Database.conexionDB();
    var respuesta = await conn.query(
      "SELECT * FROM usuarios WHERE nombreUsuario = ?",
      [datos['registro']],
    );
    bool existe = respuesta.isNotEmpty;
    if (existe) {
      return false; //usuario existe,no se registra
    } else {
      //como el usuario no existe,se guarda
      var datosId = await conn.query(
        'INSERT INTO usuarios(nombreReal,nombreUsuario,contrasenna) VALUES (?,?,?)',
        [datos['nombre'], datos['registro'], datos['contra']],
      );
      //creacion del historial de monstruos
      await conn.query(
        'INSERT INTO historialmonstruos(historial,idUser) VALUES(?,?,?)',
        ['', datosId.insertId],
      ); //id de usuario y datos en blanco
      await conn.close();
      return true;
    }
  }

  static Future<void> borrarUsuario(int? idUsuario) async {}
}
