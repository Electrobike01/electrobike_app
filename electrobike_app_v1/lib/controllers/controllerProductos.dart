import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:electrobike_app_v1/models/modeloProductos.dart';

class ControllerProductos {
  List<ModeloProducto> productosFromJson(String jsonstring) {
    final data = json.decode(jsonstring);
    return List<ModeloProducto>.from(
        data.map((item) => ModeloProducto.fromJson(item)));
  }

  // GET PRODUCTOS
  Future<List<ModeloProducto>> getProductos() async {
    String get_productos =
        "http://192.168.0.4/apiElectrobike_app/productos/listarProductos.php";
    final response = await http.get(Uri.parse(get_productos));
    if (response.statusCode == 200) {
      List<ModeloProducto> list = productosFromJson(response.body);
      return list;
    } else {
      return <ModeloProducto>[];
    }
  }

  // SET DATA
  Future<String> addProducto(ModeloProducto ModeloProducto) async {
    String set_productos =
        "http://192.168.0.4/apiElectrobike_app/productos/registrarProductos.php";

    final response = await http.post(Uri.parse(set_productos),
        body: ModeloProducto.toJsonAdd());
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error';
    }
  }

  //Actualizar 
  Future<String> updateProducto(ModeloProducto ModeloProducto) async{
    String actualizar_productos =
        "http://192.168.0.4/apiElectrobike_app/productos/ActualizarProductos.php";
    final response = await http.post(Uri.parse(actualizar_productos),
        body: ModeloProducto.toJsonUpdate());    
     if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error';
    }
  }




  // Validar nombre y correos repetidos D
  Future<bool> ValidarProducto(
      String nombreProducto, String categoriaProducto) async {
    final response = await http.get(Uri.parse(
        "http://192.168.0.4/apiElectrobike_app/productos/validarRepetidos.php?nombreProducto=$nombreProducto&categoriaProducto=$categoriaProducto"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['isUnique'];
    } else {
      return false;
    }
  }

  // Validar nombre y correos repetidos D
  Future<bool> ValidarRepetidosActualizar(String idProducto, 
      String nombreProducto, String categoriaProducto) async {
    final response = await http.get(Uri.parse(
        // "http://192.168.0.4/apiElectrobike_app/productos/validarRepetidos.php?nombreProducto=$nombreProducto&categoriaProducto=$categoriaProducto"
        "http://192.168.0.4/apiElectrobike_app/productos/validarActualizar.php?idProducto=$idProducto&nombreProducto=$nombreProducto&categoriaProducto=$categoriaProducto"
        ));
    if (response.statusCode == 200 ) {
      var data = json.decode(response.body);
      return data['isUnique'];
    } else {
      return false;
    }
  }
}
