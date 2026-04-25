import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../utils/api.dart';

class PlayableCharacter {
  String? nombrePersonaje;
  int? fuerza;
  int? destreza;
  int? constitucion;
  int? inteligencia;
  int? sabiduria;
  int? carisma;
  String? clase;
  int? experiencia;
  String? raza;
  int? puntosVida;
  List<String>? equipoInicial;
  String? trasfondo;
  List<String>? hechizos;
  String? alineamiento;
  int? puntosGolpe;
  int? iniciativa;
  int? armadura;
  Map? velocidad;
  String? idioma;
  int? nivel;

  PlayableCharacter();

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
    hechizos = [];
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
    Uri url = Uri.parse('${Api.claveApi}classes/$clase');
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
}
