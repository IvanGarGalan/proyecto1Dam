import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api.dart';

class PlayableCharacter {
  String nombrePersonaje;
  int fuerza;
  int destreza;
  int constitucion;
  int inteligencia;
  int sabiduria;
  int carisma;
  String clase;
  int experiencia;
  String raza;
  int puntosVida;
  List<String> equipoInicial;
  String trasfondo;
  List<String>? hechizos;
  String alineamiento;
  int puntosGolpe;
  int iniciativa;
  int armadura;
  Map velocidad;
  String idioma;

  PlayableCharacter(
    this.nombrePersonaje,
    this.clase,
    this.fuerza,
    this.destreza,
    this.constitucion,
    this.inteligencia,
    this.sabiduria,
    this.carisma,
    this.experiencia,
    this.raza,
    this.puntosVida,
    this.equipoInicial,
    this.trasfondo,
    this.hechizos,
    this.alineamiento,
    this.puntosGolpe,
    this.iniciativa,
    this.armadura,
    this.velocidad,
    this.idioma,
  );

  //constructor que prepara los datos de la API al objeto personaje
  PlayableCharacter.datosAPI(datos) {}

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
