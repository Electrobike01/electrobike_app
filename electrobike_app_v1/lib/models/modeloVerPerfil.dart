class VerPerfilModel {
  int idUsuario;
  String nombreUsuario;
  String? tipoDocumentoUsuario;
  String? documentoUsuario;
  String correoUsuario;
  String? contrasenaUsuario;
  String estadoUsuario;
  int? idRol;
  String? nombreRol;

  VerPerfilModel({
    required this.idUsuario,
    required this.nombreUsuario,
    this.tipoDocumentoUsuario,
    this.documentoUsuario,
    required this.correoUsuario,
    this.contrasenaUsuario,
    required this.estadoUsuario,
    this.idRol,
    this.nombreRol,
  });

   factory VerPerfilModel.fromJson(Map<String, dynamic> json) {
    return VerPerfilModel(
      idUsuario: json['idUsuario'],
      nombreUsuario: json['nombreUsuario'],
      tipoDocumentoUsuario: json['tipoDocumentoUsuario'],
      documentoUsuario: json['documentoUsuario'],
      correoUsuario: json['correoUsuario'],
      contrasenaUsuario: json['contrasenaUsuario'],
      estadoUsuario: json['estadoUsuario'],
      idRol: json['idRol'],
      nombreRol: json['nombreRol'],
    );
  }

   Map<String, dynamic> toJsonValidateUpdate() {
    return {
      "idUsuario": idUsuario,
      "documentoUsuario": documentoUsuario,
    };
  }

    Map<String, dynamic> toJsonUpdate() {
    return {
      "idUsuario": idUsuario,
      "nombreUsuario": nombreUsuario,
      "tipoDocumentoUsuario": tipoDocumentoUsuario,
      "documentoUsuario": documentoUsuario,
      "correoUsuario": correoUsuario,
      "idRol": idRol,
      "estadoUsuario": estadoUsuario,
    };
  }

}
