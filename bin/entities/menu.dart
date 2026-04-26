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
  //TO DO:3.Mostrar personajes(e imprimir),4.Ver opciones de usuario,
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
          //nombre
          stdout.writeln(
            "Vamos a crear un personaje,empecemos por el nombre¿Cual será?",
          );
          String nombrePersonaje = stdin.readLineSync() ?? 'Drizt';
          //stats
          stdout.writeln(
            "Ahora vamos con las estadisticas,puedes elegir si todas serán aleatorias(tiradas d20) o usar la numeración estandar en este orden(15,12,14,10,13,8)",
          );
          stdout.writeln("1.Aleatorio 2.Estandar");
          String numerosElegir = stdin.readLineSync() ?? '1';
          int numeroStats = int.tryParse(numerosElegir) ?? 0;
          //lista para las estadisticas, si se eligen aleatorios,se borran y se añaden
          List<int> stats = [15, 12, 14, 10, 13, 8];
          if (numeroStats == 1) {
            stats.clear(); //la lista se limpia
            for (var i = 0; i <= 5; i++) {
              stats.add(Random().nextInt(20) + 1);
            }
          }
          //raza
          stdout.writeln(
            "Elige una raza:1.Humano,2.Elfo,3.Orco,4.Enano,5.Gnomo,6.Semielfo",
          );
          numerosElegir = stdin.readLineSync() ?? '1';
          int numeroRaza = int.tryParse(numerosElegir) ?? 1;
          String raza = recogerRaza(numeroRaza);
          //trasfondo
          stdout.writeln(
            "Elige un transfondo:1.Soldado,2.Explorador,3.Mercenario",
          );
          numerosElegir = stdin.readLineSync() ?? '1';
          int numeroTrasfondo = int.tryParse(numerosElegir) ?? 1;
          String trasfondo = recogerTrasfondo(numeroTrasfondo);
          //alineamiento
          stdout.writeln("Elige un alineamiento:1.Bueno,2.Neutral,3.Maligno");
          numerosElegir = stdin.readLineSync() ?? '1';
          int numeroAlineamiento = int.tryParse(numerosElegir) ?? 1;
          String alineamiento = recogerAlineamiento(numeroAlineamiento);
          //clase
          stdout.writeln(
            'Elige una clase:1.Barbaro,2.Bardo,3.Clerigo,4.Mago,5.Paladín,6.Pícaro',
          );
          numerosElegir = stdin.readLineSync() ?? '1';
          int numeroClase = int.tryParse(numerosElegir) ?? 1;
          String clase = recogerClase(numeroClase);
          //creacion del persoanje y añadirlo a la base de datos
          PlayableCharacter? pj = await PlayableCharacter.obtenerPersonaje(
            nombrePersonaje,
            stats,
            raza,
            trasfondo,
            alineamiento,
            clase,
          );
          if (pj != null) {
            stdout.writeln(
              'Se ha creado el personaje $nombrePersonaje de forma correcta.',
            );
            bool insertado = await pj.insertarPersonaje();
            if (insertado) {
              stdout.writeln('Personaje guardado correctamente');
            }
          } else {
            stdout.writeln(
              'No se ha podido crear el personaje $nombrePersonaje,vuelve a intentarlo de nuevo',
            );
          }
          break;
        case '3':
          stdout.writeln("Mostrar tus personajes");
          List<PlayableCharacter>? personajes = await mostarPersonajes();
          if (personajes != null && personajes.isNotEmpty) {
            stdout.writeln('Se han encontrado los siguientes personajes');
            //para poder mostrar numeros en la lista y luego poder imprimirlos
            int numeroDb = 1;
            for (var personaje in personajes) {
              stdout.writeln(
                'Número:$numeroDb Nombre: ${personaje.nombrePersonaje} Clase: ${personaje.clase}',
              );
              numeroDb++;
            }
          } else {
            stdout.writeln(
              'No se han podido encontrar personajes,prueba a crear un par',
            );
          }
          //print('WIP');
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

  //metodo que recibe un numero y devuelve la raza seleccionada en String
  static String recogerRaza(int numeroRaza) {
    switch (numeroRaza) {
      case 1:
        return 'Humano';
      case 2:
        return 'Elfo';
      case 3:
        return 'Orco';
      case 4:
        return 'Enano';
      case 5:
        return 'Gnomo';
      case 6:
        return 'Semielfo';
      //por defecto,devuelve humano
      default:
        return 'Humano';
    }
  }

  //metodo que recoge el numeroTrasfondo y devuelve ese trasfondo en switch
  static String recogerTrasfondo(int numeroTrasfondo) {
    switch (numeroTrasfondo) {
      case 1:
        return 'Soldado';
      case 2:
        return 'Explorador';
      case 3:
        return 'Mercenario';
      //por defecto,devuelve soldado
      default:
        return 'Soldado';
    }
  }

  static String recogerAlineamiento(int numeroAlineamiento) {
    switch (numeroAlineamiento) {
      case 1:
        return 'Bueno';
      case 2:
        return 'Neutral';
      case 3:
        return 'Maligno';
      default:
        //por defecto,devuelve Bueno
        return 'Bueno';
    }
  }

  //metodo que recoge una clase desde un número para poder darsela a la api
  static String recogerClase(int numeroClase) {
    //'Elige una clase:1.Barbaro,2.Bardo,3.Clerigo,4.Mago,5.Paladín,6.Pícaro'
    switch (numeroClase) {
      case 1:
        return 'barbarian';
      case 2:
        return 'bard';
      case 3:
        return 'cleric';
      case 4:
        return 'wizard';
      case 5:
        return 'paladin';
      case 6:
        return 'rogue';
      default:
        //por defecto,retorna Paladin
        return 'paladin';
    }
  }

  //metodo qeu retorna una lista de personajes de la base de datos
  static Future<List<PlayableCharacter>?> mostarPersonajes() async {
    var conn = await Database.conexionDB();
    try {
      var resultados = await conn.query(
        'SELECT nombrePersonaje,clase FROM personajes WHERE idPersonaje IN (SELECT idpersonaje FROM usuariospersonajes WHERE iduser = ?)',
        [Sesion.usuario!.idUsuario],
      );
      //poner cada fila a un elemento personaje
      List<PlayableCharacter> personajes = resultados.map((row) {
        return PlayableCharacter.list(row['nombrePersonaje'], row['clase']);
      }).toList();

      conn.close();
      return personajes;
    } catch (e) {
      print(e);
      conn.close();
      return null;
    }
  }
}
