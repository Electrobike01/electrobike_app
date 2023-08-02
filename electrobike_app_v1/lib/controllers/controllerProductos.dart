import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:electrobike_app_v1/models/modeloProductos.dart';

class ControllerProductos {

//   Future<List<Map<String, dynamic>>> getCantCompras() async {
//   String url = "http://192.168.0.4/apiElectrobike_app/productos/graficaTorta.php";
//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//       final List<dynamic> jsonData = json.decode(response.body);
//       return jsonData.isNotEmpty ? jsonData[0] : {};
//   } else {
//      throw Exception('Fallo al cargar');
//   }
// }

// ====================== METODO GET PARA GRAFICA TODOS LOS PRODUCTOS =====================================
  Future<List<Map<String, dynamic>>> getChartData() async {
  String url = "http://192.168.0.4/apiElectrobike_app/productos/graficaTorta.php";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<Map<String, dynamic>> data = json.decode(response.body).cast<Map<String, dynamic>>();
    return data;
  } else {
    return [];
  }
}



  List<ModeloProducto> productosFromJson(String jsonstring) {
    final data = json.decode(jsonstring);
    return List<ModeloProducto>.from(
        data.map((item) => ModeloProducto.fromJson(item)));
  }

  // ============================ GET LISTA PRODUCTOS ===============================
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

  // ============================== SET PRODUCTOS ===================================
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

  // =============================== PUT PRODUCTOS ==================================================
  Future<String> updateProducto(ModeloProducto ModeloProducto) async {
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

  // ========================== VALIDAR PRODUCTOS REPETIDOS (REGISTRAR) =============================== 
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

  // ========================== VALIDAR PRODUCTOS REPETIDOS (ACTUALIZAR) =============================== 
  Future<bool> ValidarRepetidosActualizar(String idProducto,
      String nombreProducto, String categoriaProducto) async {
    final response = await http.get(Uri.parse(
        "http://192.168.0.4/apiElectrobike_app/productos/validarActualizar.php?idProducto=$idProducto&nombreProducto=$nombreProducto&categoriaProducto=$categoriaProducto"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['isUnique'];
    } else {
      return false;
    }
  }
}
