import 'dart:io';

abstract class Menu {
  static void menuInicio() {
    stdout.writeln('''
    Elige una opción:
    1.Iniciar sesión
    2.Salir de la aplicación

''');
  }
}
