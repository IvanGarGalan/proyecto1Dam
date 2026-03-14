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
}
