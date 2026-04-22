import 'dart:io';
import 'entities.dart';
import '../utils/utils.dart';
import 'dart:math';

abstract class Menu {
  //metodo que muestra las opciones de inicio de la app
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
          stdout.writeln("Registrarse");
          Map<String, String> datosRegistro =
              registroUsuario(); //mapa al que se le asigna los datos devueltos del registro
          bool registrado = await Usuario.registro(datosRegistro);
          if (registrado) {
            stdout.writeln("El usuario se ha registrado correctamente");
          } else {
            stdout.writeln(
              "No se han podido reconocer los datos,vuelve a intentarlo",
            );
          }
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

  //metodo que sirve para crear un mapa con los datos de registro
  static Map<String, String> registroUsuario() {
    String nombrePersona;
    String nombreRegistroUsuario;
    String contrasenna;
    //mapa para que devuelva datos y se puedan comparar con la base de datos
    Map<String, String> datos = {};
    do {
      stdout.writeln("Introduce tu nombre real");
      nombrePersona = stdin.readLineSync() ?? "";
      stdout.writeln("Introduce un nombre de usuario");
      nombreRegistroUsuario = stdin.readLineSync() ?? "ERROR";
      stdout.writeln("Introduce una contraseña");
      contrasenna = stdin.readLineSync() ?? "";

      //comprobar que la contraseña tenga seis carqacteres
      if (contrasenna.length < 6) {
        stdout.writeln(
          "La contraseña no tiene mas de seis caracteres,debes introducir mas de seis caracteres",
        );
      }
      if (nombrePersona.isEmpty ||
          nombreRegistroUsuario.isEmpty ||
          contrasenna.isEmpty) {
        stdout.writeln("Ningun campo puede estar vacio");
      }
    } while (nombrePersona.isEmpty || //repite si se cumplen estas condiciones
        nombreRegistroUsuario.isEmpty ||
        contrasenna.isEmpty ||
        contrasenna.length < 6);

    datos = {
      "nombre": nombrePersona,
      "registro": nombreRegistroUsuario,
      "contra": contrasenna,
    };
    return datos;
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
  //TO DO:2.Creacion de personajes,3.Mostrar personajes(e imprimir),4.Ver opciones de usuario,
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
          Monster? monstruo = await Monster.obtenerMonstruo(
            nombre.toLowerCase().replaceAll(" ", "-"),
          ); //prepara el string a minusculas y cambia los espacios por guion -
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
            print(
              'No se pudo obtener el monstruo.Vuelve a intentarlo mas tarde',
            );
          }
          break;
        case '2':
          stdout.writeln("Creación de personajes");
          stdout.writeln(
            "Vamos a crear un personaje,empecemos por el nombre¿Cual será?",
          );
          String nombrePersonaje = stdin.readLineSync() ?? 'Drizt';
          stdout.writeln(
            "Ahora vamos con las estadisticas,puedes elegir si todas serán aleatorias o usar la numeración estandar(15,12,14,10,13,8)",
          );
          stdout.writeln("1.Aleatorio 2.Estandar");
          String numerosElegir = stdin.readLineSync() ?? '1';
          int numero = int.tryParse(numerosElegir) ?? 0;
          //lista para las estadisticas, si se eligen aleatorios,se borran y se añaden
          List<int> stats = [15, 12, 14, 10, 13, 8];
          if (numero == 1) {
            stats.clear(); //la lista se limpia
            for (var i = 0; i < 5; i++) {
              stats.add(Random().nextInt(20) + 1);
            }
          }
          stdout.writeln(
            "Elige una raza:1.Humano,2.Elfo,3.Orco,4.Enano,5.Gnomo,6.Semielfo",
          );
          //TO DO: recoger las razas en switch
          stdout.writeln(
            "Elige un transfondo:1.Soldado,2.Explorador,3.Mercenario",
          );
          //TO DO: Recoger transfondo en switch
          stdout.writeln("Elige un alineamiento:1.Bueno,2.Neutral,3.Maligno");
          //to do: recoger el alineamiento en switch
          print('WIP');
          break;
        case '3':
          stdout.writeln("Mostrar tus personajes");
          print('WIP');
          break;
        case '4':
          stdout.writeln("Tus opciones de usuario");
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
