// ======================== IMPORTACIONES ========================
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:electrobike_app_v1/models/modeloProductos.dart';

// Se crea la clase que contiene los metodos
class ControllerProductos {
  // Obtener los datos para el grafico de torta
  Future<List<Map<String, dynamic>>> getChartData() async {
    String url =
        "http://192.168.0.4/apiElectrobike_app/productos/graficaTorta.php";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data =
          json.decode(response.body).cast<Map<String, dynamic>>();
      return data;
    } else {
      return [];
    }
  }

  // Obtener los datos para la grafica lineal
  Future<Map<String, dynamic>> getComprasYVentasPorMes() async {
    String url =
        "http://192.168.0.4/apiElectrobike_app/productos/graficaLineal.php";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      return jsonData;
    } else {
      return {};
    }
  }

  // Obtener los datos de las tarjetas del dashboard
  Future<Map<String, dynamic>> getRecuadros() async {
    String url =
        "http://192.168.0.4/apiElectrobike_app/productos/recuadros.php";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      return {};
    }
  }

Future<List<Map<String, dynamic>>> getTopProductos({required int year, required int month}) async {
  String url = "http://192.168.0.4/apiElectrobike_app/productos/5productos.php?year=$year&month=$month";
  print(url);
  final response = await http.get(Uri.parse(url));
  print(response.body);
  

  if (response.statusCode == 200) {
    Map<String, dynamic> Data = json.decode(response.body);
    List<Map<String, dynamic>> productos = List<Map<String, dynamic>>.from(Data['productos']);
    return productos;
  } else {
    return [];
  }
}

Future<List<Map<String, dynamic>>> getTopClientes({required int year, required int month}) async {
  String url = "http://192.168.0.4/apiElectrobike_app/productos/5clientes.php?year=$year&month=$month";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    List<Map<String, dynamic>> clientes = List<Map<String, dynamic>>.from(data['clientes']);
    return clientes;
  } else {
    return [];
  }
}

  // Metodo para sacar los productos del Json
  List<ModeloProducto> productosFromJson(String jsonstring) {
    final data = json.decode(jsonstring);
    return List<ModeloProducto>.from(
        data.map((item) => ModeloProducto.fromJson(item)));
  }

  // Trae los productos de la base de datos
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

  // Registrar productos a la  base de datos
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

  // Validar que el producto no exista dentro de la categoria para registrar
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

  // Metodo para actualizar productos
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

  // Validar que no exista dentro de la categoria al momento de registrar
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

  // Validar que el producto no exista dentro de la categoria para registrar
  Future<bool> ValidarEliminar(int idProducto) async {
    try {
    final response = await http.get(Uri.parse("http://192.168.0.4/apiElectrobike_app/productos/validarEliminar.php?idProducto=$idProducto"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['isUnique'];
    } else {
      return false;
    }  
    } catch (e) {
      print('Errorrr: $e');
     return false; 
    }
    
  }

  
  // Validar que el producto no exista dentro de la categoria para registrar
  Future<bool> eliminarProducto(int idProducto) async {
    try {
    final response = await http.get(Uri.parse("http://192.168.0.4/apiElectrobike_app/productos/eliminarProducto.php?idProducto=$idProducto"));
    if (response.statusCode == 200) {
      // var data = json.decode(response.body);
      // return data['isUnique'];
      return true;
    } else {
      return false;
    }  
    } catch (e) {
      print('Errorrr: $e');
     return false; 
    }
    
  }
}
