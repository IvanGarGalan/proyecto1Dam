import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import '../utils/utils.dart';
import 'characterentity.dart';

class PlayableCharacter extends CharacterEntity {
  String? nombrePersonaje;
  String? clase;
  int? experiencia;
  String? raza;
  int? puntosVida;
  String? equipoInicial;
  String? trasfondo;
  String? hechizos;
  String? alineamiento;
  int? iniciativa;
  int? armadura;
  int? nivel;

  PlayableCharacter();
  //constructor para mostar personajes en una lista,solo con nombre y la clase
  PlayableCharacter.list(this.nombrePersonaje, this.clase);

  //constructor que prepara los datos de la API al objeto personaje
  PlayableCharacter.datosAPI(
    datos,
    String nombre,
    List<int> stats,
    String raza,
    String trasfondo,
    String alineamiento,
  ) {
    nombrePersonaje = nombre;
    clase = datos['name'];
    fuerza = stats[0];
    destreza = stats[1];
    constitucion = stats[2];
    inteligencia = stats[3];
    sabiduria = stats[4];
    carisma = stats[5];
    experiencia = 0;
    this.raza = raza;
    puntosVida = 2 + stats[2]; //puntos de vida con constitucion
    equipoInicial = datos['starting_equipment'][0]['equipment']['name'];
    this.trasfondo = trasfondo;
    hechizos = '';
    this.alineamiento = alineamiento;
    puntosGolpe = datos['hit_die'];
    iniciativa =
        stats[1] +
        Random().nextInt(20) +
        1; // to do: poner iniciativa(destreza + d20)
    armadura = 10 + stats[1]; //armadura (10 + destreza)
    velocidad = {'walk': '10ft'}; //caminar estandar de un personaje jugable
    idioma = 'Común';
    nivel = 1;
  }

  //metodo que trae los datos de clase de api y ayuda a crear la clase character
  static Future<PlayableCharacter?> obtenerPersonaje(
    String nombrePersonaje,
    List<int> stats,
    String raza,
    String trasfondo,
    String alineamiento,
    String clase,
  ) async {
    Uri url = Uri.parse('https://www.dnd5eapi.co/api/2014/classes/$clase');
    var respuesta = await http.get(url);
    try {
      if (respuesta.statusCode == 200) {
        var body = json.decode(respuesta.body);
        PlayableCharacter personaje = PlayableCharacter.datosAPI(
          body,
          nombrePersonaje,
          stats,
          raza,
          trasfondo,
          alineamiento,
        );
        return personaje;
      } else if (respuesta.statusCode == 404) {
        throw ('No se ha podido hacer el personaje,vuelve a intentarlo mas tarde');
      }
    } catch (e) {
      print(e);
    }
  }

  //metodo que introduce el personaje en la base de datos y lo relaciona con el usuario
  Future<bool> insertarPersonaje() async {
    MySqlConnection conn = await Database.conexionDB();
    try {
      //cambiar las listas a json
      String equipoInicialJson = jsonEncode(equipoInicial ?? []);
      String hechizosJson = jsonEncode(hechizos ?? []);
      String velocidadJson = jsonEncode(velocidad ?? {});

      var personajeIntroducido = await conn.query(
        'INSERT INTO personajes(nombrePersonaje,fuerza,destreza,constitucion,inteligencia,sabiduria,carisma,clase,experiencia,raza,puntosVida,equipoInicial,trasfondo,hechizos,alineamiento,puntosGolpe,iniciativa,armadura,velocidad,idioma,nivel) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          nombrePersonaje,
          fuerza,
          destreza,
          constitucion,
          inteligencia,
          sabiduria,
          carisma,
          clase,
          experiencia,
          raza,
          puntosVida,
          equipoInicialJson,
          trasfondo,
          hechizosJson,
          alineamiento,
          puntosGolpe,
          iniciativa,
          armadura,
          velocidadJson,
          idioma,
          nivel,
        ],
      );

      //sacar el id de personaje ya introducido
      var idPersonaje = personajeIntroducido.insertId;
      //insertar el idPersonaje con el usuario en base de datos
      await conn.query(
        'INSERT INTO usuariospersonajes(iduser,idpersonaje) VALUES (?,?)',
        [Sesion.usuario!.idUsuario, idPersonaje],
      );
      await conn.close();
      return true;
    } catch (e) {
      await conn.close();
      return false;
    }
  }

  //metodo que imprime todos los datos de un personaje en txt
  static Future<bool> imprimirPersonajeTexto(String personajeNombre) async {
    var conn = await Database.conexionDB();
    try {
      var resultados = await conn.query(
        'SELECT * FROM personajes WHERE nombrePersonaje = ?',
        [personajeNombre],
      );
      conn.close();
      //impresion del personaje
      print('Nombre ${resultados.first[1]}');
      File archivoPersonaje = File('Hoja de personaje de $personajeNombre');

      archivoPersonaje.writeAsString('''

    ============Nombre: ${resultados.first[1]}==================
      Clase: ${resultados.first[8]}
      Raza: ${resultados.first[10]} 
      Puntos de vida: ${resultados.first[11]} 
      Trasfondo: ${resultados.first[13]}
      Alineamiento: ${resultados.first[15]} 
      Puntos de golpe: ${resultados.first[16]} 
      Iniciativa: ${resultados.first[17]} 
      Armadura: ${resultados.first[18]} 
      Nivel: ${resultados.first[21]}
      Experiencia:${resultados.first[9]} puntos
      
    ===Estadisticas:============================
        -Fuerza: ${resultados.first[2]}
        -Destreza: ${resultados.first[3]}
        -Constitución: ${resultados.first[4]}
        -Inteligencia: ${resultados.first[5]}
        -Sabiduria: ${resultados.first[6]}
        -Carisma: ${resultados.first[7]}

    ============================================  
      Equipo Inicial: ${resultados.first[12]}
      Hechizos: ${resultados.first[14]} 
      Velocidad: ${resultados.first[19]} 
      Idioma: ${resultados.first[20]} 
      ''', mode: FileMode.append);

      return true;
    } catch (e) {
      print(e);
      conn.close();
      return false;
    }
  }
}
