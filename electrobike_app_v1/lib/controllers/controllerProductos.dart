// ======================== IMPORTACIONES ========================
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:electrobike_app_v1/models/modeloProductos.dart';

// Se crea la clase que contiene los metodos
class ControllerProductos {

  String dir = "http://192.168.0.4/apiElectrobike_app/";

  // Obtener los datos para el grafico de torta
  Future<List<Map<String, dynamic>>> getChartData() async {
    String url =
        // "https://electrobike-adso.000webhostapp.com/apiElectrobike_app/productos/graficaTorta.php";
        "https://electrobike-adso-wild.000webhostapp.com/controllers/productos/Movil/graficaTortaMovil.php";
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
        "https://electrobike-adso-wild.000webhostapp.com/controllers/productos/Movil/graficaLinealMovil.php";
        // "http://192.168.0.4/apiElectrobike_app/productos/graficaLineal.php";
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
        "https://electrobike-adso-wild.000webhostapp.com/controllers/productos/Movil/recuadrosMovil.php";
        // "http://192.168.0.4/apiElectrobike_app/productos/recuadros.php";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      return {};
    }
  }

  // Obtener los datos de los productos mas vendidos 
  Future<List<Map<String, dynamic>>> getTopProductos({required int year, required int month}) async {
    String url = 
    "https://electrobike-adso-wild.000webhostapp.com/controllers/productos/Movil/5productos.php?year=$year&month=$month";
    // "http://192.168.0.4/apiElectrobike_app/productos/5productos.php?year=$year&month=$month";
    // print(url);
    final response = await http.get(Uri.parse(url));
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> Data = json.decode(response.body);
      List<Map<String, dynamic>> productos = List<Map<String, dynamic>>.from(Data['productos']);
      return productos;
    } else {
      return [];
    }
  }

  // Obtener los datos de la grafica top clientes
  Future<List<Map<String, dynamic>>> getTopClientes({required int year, required int month}) async {
    String url = 
    "https://electrobike-adso-wild.000webhostapp.com/controllers/productos/Movil/5clientes.php?year=$year&month=$month";
    // "http://192.168.0.4/apiElectrobike_app/productos/5clientes.php?year=$year&month=$month";
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
        "https://electrobike-adso-wild.000webhostapp.com/controllers/productos/Movil/listarProductosMovil.php";
        // "http://192.168.0.4/apiElectrobike_app/productos/listarProductos.php";
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
        "https://electrobike-adso-wild.000webhostapp.com/controllers/productos/Movil/registrarProductosMovil.php";
        // "http://192.168.0.4/apiElectrobike_app/productos/registrarProductos.php";
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
        "https://electrobike-adso-wild.000webhostapp.com/controllers/productos/Movil/validarRepetidosMovil.php?nombreProducto=$nombreProducto&categoriaProducto=$categoriaProducto"));
        // "http://192.168.0.4/apiElectrobike_app/productos/validarRepetidos.php?nombreProducto=$nombreProducto&categoriaProducto=$categoriaProducto"));
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
        "https://electrobike-adso-wild.000webhostapp.com/controllers/productos/Movil/actualizarProductosMovil.php";
        // "http://192.168.0.4/apiElectrobike_app/productos/actualizarProductos.php";
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
        "https://electrobike-adso-wild.000webhostapp.com/controllers/productos/Movil/validarActualizarMovil.php?idProducto=$idProducto&nombreProducto=$nombreProducto&categoriaProducto=$categoriaProducto"
        // "http://192.168.0.4/apiElectrobike_app/productos/validarActualizar.php?idProducto=$idProducto&nombreProducto=$nombreProducto&categoriaProducto=$categoriaProducto"
        
        ));
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
    final response = await http.get(Uri.parse(
      "https://electrobike-adso-wild.000webhostapp.com/controllers/productos/Movil/validarEliminarMovil.php?idProducto=$idProducto"
      // "http://192.168.0.4/apiElectrobike_app/productos/validarEliminar.php?idProducto=$idProducto"
      
      ));
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
    final response = await http.get(Uri.parse(
      "https://electrobike-adso-wild.000webhostapp.com/controllers/productos/Movil/eliminarProductoMovil.php?idProducto=$idProducto"
      // "http://192.168.0.4/apiElectrobike_app/productos/eliminarProducto.php?idProducto=$idProducto"
      
      ));
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
