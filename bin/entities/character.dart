import 'dart:io';
import 'dart:convert';
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
  PlayableCharacter.datosAPI(datos) {
    nombrePersonaje = 'abcd'; // to do: poner variable con nombre
    clase = datos['name'];
    fuerza = 10;
    destreza = 10;
    constitucion = 10;
    inteligencia = 10;
    sabiduria = 10;
    carisma = 10;
    experiencia = 0;
    raza = 'Humano'; //to do: poner raza
    puntosVida = 8; //to do: poner puntos de vida con constitucion
    equipoInicial = [];
    trasfondo = ''; // to do: poner transfondo
    hechizos = [];
    alineamiento = ''; // to do: poner alineamiento
    puntosGolpe = datos['hit_die'];
    iniciativa = 0; // to do: poner iniciativa(destreza + d20)
    armadura = 0; // to do: poner armadura (10 + destreza)
    velocidad = {30, 'ft'} as Map<dynamic, dynamic>;
    idioma = 'Común';
    nivel = 1;
  }

  //metodo que trae los datos de clase de api y ayuda a crear la clase character
  static Future<PlayableCharacter?> obtenerPersonaje(String clase) async {
    Uri url = Uri.parse('${Api.claveApi}classes/$clase');
    var respuesta = await http.get(url);
    try {
      if (respuesta.statusCode == 200) {
        var body = json.decode(respuesta.body);
        PlayableCharacter personaje = PlayableCharacter.datosAPI(body);
      } else if (respuesta.statusCode == 404) {
        throw ('No se ha podido hacer el personaje,vuelve a intentarlo mas tarde');
      }
    } catch (e) {
      print(e);
    }
  }
}
