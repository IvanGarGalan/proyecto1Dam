class Character {
  String nombre;
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

  Character(
    this.nombre,
    this.fuerza,
    this.destreza,
    this.constitucion,
    this.inteligencia,
    this.sabiduria,
    this.carisma,
    this.clase,
    this.experiencia,
    this.raza,
    this.puntosVida,
  );

  //metodo que trae los datos de clase de api y ayuda a crear la clase character
  static Future<Character?> obtenerPersonaje() async {}
}
