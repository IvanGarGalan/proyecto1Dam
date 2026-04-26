import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/utils.dart';

class Monster {
  String? nombre;
  String? tamanio;
  String? tipo;
  String? aliniamiento;
  int? puntosGolpe;
  String? dadosGolpe;
  String? tiradaDanio;
  List? claseArmadura;
  Map? velocidad;
  int? fuerza;
  int? destreza;
  int? constitucion;
  int? inteligencia;
  int? sabiduria;
  int? carisma;
  int? experiencia;
  List? proficiencias;
  List<dynamic>? vulnerabilidades;
  List<dynamic>?
  resistenciasDanio; //TO DO: TERMINAR ESTOS TRES,PONER LISTA CORRECTAMETE
  List<dynamic>?
  inmunidadDanio; //TO DO: TERMINAR ESTOS TRES,PONER LISTA CORRECTAMETE
  List<dynamic>?
  inmunidadCondicion; //TO DO: TERMINAR ESTOS TRES,PONER LISTA CORRECTAMETE
  String? idioma;
  int? nivelDesafio;
  int? bonusCompetencia;
  List? formas;
  List? accionesLegend;
  List? reacciones;

  Monster();

  //constructor que asigna los datos de la api al objeto Monstruo
  Monster.datosAPI(datos) {
    nombre = datos['name'];
    tamanio = datos['size'];
    tipo = datos['type'];
    aliniamiento = datos['alignment'];
    puntosGolpe = datos['hit_points'];
    dadosGolpe = datos['hit_dice'];
    tiradaDanio = datos['hit_points_roll'];
    claseArmadura = datos['armor_class'];
    velocidad = datos['speed'];
    //----------estadisticas------------------
    fuerza = datos['strength'];
    destreza = datos['dexterity'];
    constitucion = datos['constitution'];
    inteligencia = datos['intelligence'];
    sabiduria = datos['wisdom'];
    carisma = datos['charisma'];
    //----------------------------------------
    experiencia = datos['xp'];
    proficiencias = datos['proficiencies'];
    vulnerabilidades = datos['damage_vulnerabilities'];
    resistenciasDanio = datos['damage_resistances'];
    inmunidadDanio = datos['damage_immunities'];
    inmunidadCondicion = datos['condition_immunities'];
    idioma = datos['languages'];
    nivelDesafio = datos['challenge_rating'];
    bonusCompetencia = datos['proficiency_bonus'];
    formas = datos['forms'];
    accionesLegend = datos['legendary_actions'];
    reacciones = datos['reactions'];
  }

  //Metodo que imprime los datos en un .txt
  void imprimirDatosTexto(Monster monstruo) async {
    File archivoMonstruo = File('archivo$nombre.txt');

    archivoMonstruo.writeAsString('''
    ============Nombre $nombre==================
      Tamaño: $tamanio
      Tipo: $tipo
      Alineamiento: $aliniamiento
      Puntos de golpe: $puntosGolpe
      Dados de golpe: $dadosGolpe
      Tirada de daño: $tiradaDanio
      Clase de armadura: $claseArmadura
      Velocidad: $velocidad
      
    ===Estadisticas:============================
        -Fuerza: $fuerza
        -Destreza: $destreza
        -Constitución: $constitucion
        -Inteligencia: $inteligencia
        -Sabiduria: $sabiduria
        -Carisma: $carisma
      Experiencia: $experiencia puntos
      Proficencias: $proficiencias
    ============================================  
      Vulnerabilidades: $vulnerabilidades
      Resistencias de daño: $resistenciasDanio
      Inmunidades de daño: $inmunidadDanio
      Inmunidaes de condición: $inmunidadCondicion
      Idioma: $idioma
      Nivel de desafio: $nivelDesafio
      Bonus de competencia: $bonusCompetencia
      Formas: $formas
      Acciones legendarias: $accionesLegend
      Reacciones: $reacciones  
      ''', mode: FileMode.append); //append pone mas de una linea
  }

  //Metodo que trae datos de la api y crea el objeto Monstruo
  static Future<Monster?> obtenerMonstruo(String nombre) async {
    Uri url = Uri.parse(
      '${Api.claveApi}monsters/$nombre',
    ); //para no repetir la clave de la api todo el tiempo
    var respuesta = await http.get(url);
    try {
      if (respuesta.statusCode == 200) {
        var body = json.decode(
          respuesta.body,
        ); //paso de la respuesta de json a variable
        Monster monstruo = Monster.datosAPI(body);
        return monstruo;
      } else if (respuesta.statusCode == 404) {
        throw ('No se han podido encontrar los datos,vuelve a intentarlo mas tarde');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  //Metodo que imprime los datos del monstruo en terminal
  void imprimirInfo() {
    stdout.writeln('''
      Nombre: $nombre
      Tamaño: $tamanio
      Tipo: $tipo
      Alineamiento: $aliniamiento
      Puntos de golpe: $puntosGolpe
      Dados de golpe: $dadosGolpe
      Tirada de daño: $tiradaDanio
      Clase de armadura: $claseArmadura
      Velocidad: $velocidad
      Estadisticas:
        -Fuerza: $fuerza
        -Destreza: $destreza
        -Constitución: $constitucion
        -Inteligencia: $inteligencia
        -Sabiduria: $sabiduria
        -Carisma: $carisma
      Experiencia: $experiencia puntos
      Proficencias: $proficiencias
      Vulnerabilidades: $vulnerabilidades
      Resistencias de daño: $resistenciasDanio
      Inmunidades de daño: $inmunidadDanio
      Inmunidaes de condición: $inmunidadCondicion
      Idioma: $idioma
      Nivel de desafio: $nivelDesafio
      Bonus de competencia: $bonusCompetencia
      Formas: $formas
      Acciones legendarias: $accionesLegend
      Reacciones: $reacciones
''');
  }

  static void mostrarHistorial() async {
    var conn = await Database.conexionDB();
    var resultados = await conn.query(
      'SELECT historial FROM historialmosntruos WHERE idUser = ?',
      [Sesion.usuario!.idUsuario],
    ); //saca el historial del usuario
    if (resultados.isEmpty) {
      stdout.writeln('No hay historial todavia');
      return;
    }
    //muestra el resultado
    stdout.writeln(resultados.first['historial']);
  }

  Future<void> guardarHistorial() async {}
}
