import 'package:flutter/foundation.dart';
import 'package:electrobike_app_v1/controllers/controllerProductos.dart';
import 'package:electrobike_app_v1/models/modeloProductos.dart';

class ProductosProvider with ChangeNotifier {
  List<ModeloProducto> _listaProductos = [];

  List<ModeloProducto> get listaProductos => _listaProductos;

  Future<void> getAllProducts() async {
    _listaProductos = await ControllerProductos().getProductos();
    notifyListeners();
  }
}
