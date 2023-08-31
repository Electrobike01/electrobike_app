class ModeloContrasena {
  final idUsuario;
  final contrasenaUsuario;


  ModeloContrasena({
    this.idUsuario,
    this.contrasenaUsuario,
  });

    Map<String, dynamic> toJsonUpdate() {
    return {
      "idUsuario": idUsuario,
      "contrasenaUsuario": contrasenaUsuario,
    };
}
}
