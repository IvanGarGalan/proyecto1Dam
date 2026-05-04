import 'dart:io';

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
      conn.close();
      return false; //usuario existe,no se registra
    } else {
      //como el usuario no existe,se guarda
      var datosId = await conn.query(
        'INSERT INTO usuarios(nombreReal,nombreUsuario,contrasenna) VALUES (?,?,?)',
        [datos['nombre'], datos['registro'], datos['contra']],
      );
      //creacion del historial de monstruos
      var idUser = datosId.insertId;
      await conn.query(
        'INSERT INTO historialmonstruos(historial,idUser) VALUES(?,?)',
        ['', idUser],
      ); //id de usuario y datos en blanco
      await conn.close();
      return true;
    }
  }

  static Future<bool> borrarUsuario() async {
    var conn = await Database.conexionDB();
    try {
      //BORRAR PRIMERO LOS PERSONAJES
      await conn.query(
        'DELETE FROM personajes WHERE idPersonaje IN(SELECT idpersonaje FROM usuariospersonajes WHERE iduser = ?)',
        [Sesion.usuario!.idUsuario],
      );
      //BORRAR LAS UNIONES DE PERSONAJES CON USUARIOS
      await conn.query('DELETE FROM usuariospersonajes WHERE iduser = ?', [
        Sesion.usuario!.idUsuario,
      ]);
      //BORRAR EL HISTORIAL DE MOSNTRUOS
      await conn.query('DELETE FROM historialmonstruos WHERE idUser = ?', [
        Sesion.usuario!.idUsuario,
      ]);
      //por ultimo, se borra el usuario
      await conn.query('DELETE FROM usuarios WHERE idUsuario = ?', [
        Sesion.usuario!.idUsuario,
      ]);
      return true;
    } catch (e) {
      print(e);
      stdout.writeln('No se han podido borrar los datos');
      return false;
    } finally {
      conn.close();
    }
  }
}
