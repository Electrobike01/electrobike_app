class ModeloProducto {
  final idProducto;
  final nombreProducto;
  final cantidadProducto;
  final categoriaProducto;
  final estadoProducto;

  ModeloProducto(
      {this.idProducto,
      this.nombreProducto,
      this.cantidadProducto,
      this.categoriaProducto,
      this.estadoProducto});

  factory ModeloProducto.fromJson(Map<String, dynamic> json) {
    return ModeloProducto(
      idProducto: json['idProducto'],
      nombreProducto: json['nombreProducto'],
      cantidadProducto: json['cantidadProducto'],
      categoriaProducto: json['categoriaProducto'],
      estadoProducto: json['estadoProducto'],
    );
  }

  Map<String, dynamic> toJsonAdd() {
    return {
      "nombreProducto": nombreProducto,
      "categoriaProducto": categoriaProducto,
    };
  }
  
  Map<String, dynamic> toJsonValidateUpdate() {
    return {
      "idProducto": idProducto ,
      "nombreProducto": nombreProducto,
      "categoriaProducto": categoriaProducto,
    };
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      "idProducto": idProducto,
      "nombreProducto": nombreProducto,
      "cantidadProducto": cantidadProducto,
      "categoriaProducto": categoriaProducto,
      "estadoProducto": estadoProducto,
    };
  }
}
