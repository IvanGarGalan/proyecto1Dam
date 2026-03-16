import 'dart:io';
import 'entities.dart';
import '../utils/utils.dart';

abstract class Menu {
  //metodo que muestra las opciones de inicio de la app
  //TO DO:HAcer el registro de usuario
  static Future<void> menuOpciones() async {
    bool salida = false; //para poder salir del bucle correctamente
    while (true) {
      menuInicio();
      String opcion = stdin.readLineSync() ?? "0";
      switch (opcion) {
        case "1":
          stdout.writeln("Iniciar Sesión");
          bool inicio = await Menu.iniciarSesionMenu();
          if (inicio) {
            stdout.writeln('Inicio de sesion correcto');
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
          break;
        case "3":
          stdout.writeln("Has salido de la aplicacion");
          salida = true;
          break;
        default:
          stdout.writeln("Opcion no reconocida,vuelve a intentarlo");
      }
      if (salida) break;
    }
  }

  //metodo que muestra el primer menu de la aplicación,inicio de sesión ,registro o salir
  static void menuInicio() {
    stdout.writeln('''
    Elige una opción:
    1.Iniciar sesión
    2.Registrarse
    3.Salir de la aplicación
''');
  }

  //metodo menu que muestra las opciones despues de iniciar sesion.
  //TO DO:2.3.Creacion de personajes,3.Mostrar personajes(e imprimir),4.Ver opciones de usuario,
  static Future<void> menuUsuario() async {
    stdout.writeln('Bienvenido ${Sesion.usuario!.nombreReal}');
    bool salida = false;
    while (true) {
      menuUsuarioInicio();
      String opcion = stdin.readLineSync() ?? '0';
      switch (opcion) {
        case '1':
          stdout.writeln('Introduce el nombre que quieras buscar');
          String nombre = stdin.readLineSync() ?? '';
          print(nombre);
          Monster? monstruo = await Monster.obtenerMonstruo(nombre.toLowerCase().replaceAll(" ", "-"));//prepara el string a minusculas y cambia los espacios por guion -
          if (monstruo != null) {
            monstruo.imprimirInfo();
            stdout.writeln('¿Quieres imprimir la información en un archivo?');
            stdout.writeln('1.Si 2.No');
            String opcionTexto = stdin.readLineSync() ?? '';
            if (opcionTexto == '1') {
              monstruo.imprimirDatosTexto(monstruo);
              stdout.writeln('Información imprimida');
            } else {
              stdout.writeln('No se han imprimido los datos');
            }
          } else {
            print('No se pudo obtener el monstruo.Vuelve a intentarlo mas tarde');
          }
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
      if (salida) break;
    }
  }

  //metodo que muestra las opciones al usuario
  static void menuUsuarioInicio() {
    stdout.writeln('''
    Elige una opcion:
    1.Buscar criaturas
    2.Creacion de personajes
    3.Mostrar personajes
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
