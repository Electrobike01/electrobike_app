class UserProfileModel {
  final idUsuario;
  final nombreUsuario;
  final tipoDocumentoUsuario;
  final documentoUsuario;
  final correoUsuario;
  final estadoUsuario;
  final idRol;

  UserProfileModel({
    this.idUsuario,
    this.nombreUsuario,
    this.tipoDocumentoUsuario,
    this.documentoUsuario,
    this.correoUsuario,
    this.estadoUsuario,
    this.idRol,
  });

    Map<String, dynamic> toJsonUpdate() {
    return {
      "idUsuario": idUsuario,
      "nombreUsuario": nombreUsuario,
      "tipoDocumentoUsuario": tipoDocumentoUsuario,
      "documentoUsuario": documentoUsuario,
      "correoUsuario": correoUsuario,
      "estadoUsuario": estadoUsuario,
      "idRol": idRol,
    };
}
}
