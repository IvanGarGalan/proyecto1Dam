import 'dart:io';
import 'entities.dart';

abstract class Menu {
  static void menuOpciones() {
    menuInicio();
    String opcion = stdin.readLineSync() ?? "0";
    switch (opcion) {
      case "1":
        stdout.writeln("Opcion 1 seleccionada");
        iniciarSesionMenu();
        break;

      case "2":
        stdout.writeln("Opcion 2 seleccionada");
        exit(0); //salida del menu de la apllcacion y del menu
      default:
        stdout.writeln("Opcion no reconocida,vuelve a intentarlo");
        Menu.menuOpciones(); //TO DO: quitar recursividad
    }
  }

  //metodo que muestra el primer menu de la aplicación,inicio de sesión o salir
  static void menuInicio() {
    stdout.writeln('''
    Elige una opción:
    1.Iniciar sesión
    2.Salir de la aplicación

''');
  }

  //menu que muestra las opciones despues de iniciar sesion.
  static void menuUsuario(Map<String, String> datos) {
    stdout.writeln('''
    Bienvenido ${datos['usuario']},elige una opcion:
    1.Ver opciones
    2.
    3.
    4.Salir

''');
    exit(0);
  }

  //metodo para iniciar sesion en la aplicacion con un usuario y contraseña determionados
  static void iniciarSesionMenu() async {
    stdout.writeln('Introduce un nombre de usuario');
    String usuario = stdin.readLineSync() ?? "";
    stdout.writeln('Introduce una contraseña');
    String contra = stdin.readLineSync() ?? "";
    Map<String, String> datos = {'usuario': usuario, 'contra': contra};
    bool inicio = await Usuario.iniciarSesion(datos);
    if (inicio) {
      print('Inicio de sesion correcto');
      Menu.menuUsuario(datos);
    }
    print(
      'EL nombre de usuario introducido es $usuario y la contraseña es $contra',
    );
    exit(0); //TO DO:Quitar este exit
  }
}
