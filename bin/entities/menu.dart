import 'dart:io';
import 'entities.dart';
import '../utils/utils.dart';

abstract class Menu {
  static Future<void> menuOpciones() async {
    bool salida = false; //para poder salir del bucle correctamente
    while (true) {
      menuInicio();
      String opcion = stdin.readLineSync() ?? "0";
      switch (opcion) {
        case "1":
          stdout.writeln("Opcion 1 seleccionada");
          bool inicio = await Menu.iniciarSesionMenu();
          if (inicio) {
            print('Inicio de sesion correcto');
            Menu.menuUsuario();
            salida = true;
          } else {
            stdout.writeln(
              'No se ha reconocido el inicio de sesion,vuelve a intentarlo',
            );
          }
          break;

        case "2":
          stdout.writeln("Opcion 2 seleccionada");
          salida = true;
          break;
        case "3":
          stdout.writeln("Has salido de la aplicacion");
          salida = true;
          break;
        default:
          stdout.writeln("Opcion no reconocida,vuelve a intentarlo");
      }
      if (salida == true) break;
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
  //TO DO:1. Buscar criaturas con la api,2.Mostrar personajes(e imprimir),3.Creacion de personajes,4.Ver opciones de usuario,5.Salir

  static void menuUsuario() {
    stdout.writeln('Bienvenido ${Sesion.usuario!.nombreReal}');
    bool salida = false;
    while (true) {
      menuUsuarioInicio();
      String opcion = stdin.readLineSync() ?? '0';
      switch (opcion) {
        case '1':
          print('WIP');
          break;
        case '2':
          print('WIP');
          break;
        case '3':
          print('WIP');
          break;
        case '4':
          print('WIP');
          break;
        case '5':
          stdout.writeln(
            'Has salido de la aplicacion,hasta luego ${Sesion.usuario!.nombreReal}',
          );
          salida = true;
          break;
        default:
          stdout.writeln("Opcion no reconocida,vuelve a intentarlo");
      }
      if (salida == true) break;
    }
  }

  static void menuUsuarioInicio() {
    stdout.writeln('''
    Elige una opcion:
    1.Buscar criaturas
    2.Mostrar personajes
    3.Creacion de personajes
    4.Ver opciones de usuario 
    5.Salir
''');
  }

  //metodo para iniciar sesion en la aplicacion con un usuario y contraseña determionados
  static Future<bool> iniciarSesionMenu() async {
    stdout.writeln('Introduce un nombre de usuario');
    String usuario = stdin.readLineSync() ?? "";
    stdout.writeln('Introduce una contraseña');
    String contra = stdin.readLineSync() ?? "";
    Map<String, String> datos = {'usuario': usuario, 'contra': contra};
    bool inicio = await Sesion.iniciarSesion(datos);
    if (inicio) {
      return true;
    }
    return false;
  }
}
