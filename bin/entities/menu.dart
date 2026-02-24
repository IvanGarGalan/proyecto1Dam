import 'dart:io';

abstract class Menu {
  static void menuOpciones() {
    menuInicio();
    String opcion = stdin.readLineSync() ?? "0";
    switch (opcion) {
      case "1":
        stdout.writeln("Opcion 1 seleccionada");
        iniciarSesion();
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

  //metodo para iniciar sesion en la aplicacion con un usuario y contraseña determionados
  static void iniciarSesion() async {
    stdout.writeln('Introduce un nombre de usuario');
    String usuario = stdin.readLineSync() ?? "";
    stdout.writeln('Introduce una contraseña');
    String contra = stdin.readLineSync() ?? "";
    print(
      'EL nombrede usuario introducido es $usuario y la contraseña es $contra',
    );
  }
}
