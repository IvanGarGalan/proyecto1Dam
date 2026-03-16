import 'dart:io';

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
}
