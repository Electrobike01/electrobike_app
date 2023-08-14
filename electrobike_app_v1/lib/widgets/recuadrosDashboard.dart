import 'package:flutter/material.dart';
import 'package:electrobike_app_v1/controllers/controllerProductos.dart';

class CuadrosInformativos extends StatefulWidget {
  @override
  State<CuadrosInformativos> createState() => CuadrosInformativosState();
}

class CuadrosInformativosState extends State<CuadrosInformativos> {
  final ControllerProductos _controller = ControllerProductos();
  String totalCompras = '';
  String totalVentas = '';
  String ganancias = '';
  String mejorCliente = '';

  // Método para obtener los datos del servidor y actualizar el estado
  void obtenerDatos() async {
    Map<String, dynamic> recuadros = await _controller.getRecuadros();

    if (recuadros.containsKey('success') && recuadros['success']['success']) {
      double compras = double.parse(recuadros['compras'].toString());
      double ventas = double.parse(recuadros['ventas'].toString());
      double ganancia = ventas - compras;

      setState(() {
        totalCompras = compras.toStringAsFixed(0);
        totalVentas = ventas.toStringAsFixed(0);
        ganancias = ganancia.toStringAsFixed(0);
        // ganancias = (34059493 - 1929192).toString();
        mejorCliente = recuadros['cliente'];
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Llamar al método para obtener datos en el inicio
    obtenerDatos();
  }
  
  


 @override
Widget build(BuildContext context) {
  return Column(
    children: [
      SizedBox(height: 10),
      Row(
        children: [
          SizedBox(width: 10),
          Flexible(
            child: _buildCuadro("Cantidad de Compras:", totalCompras, Colors.blue),
          ),
          SizedBox(width: 10),
          Flexible(
            child: _buildCuadro("Cantidad de Ventas:", totalVentas, Colors.blueAccent),
          ),
          SizedBox(width: 10),
        ],
      ),
      SizedBox(height: 10),
      Row(
        children: [
          SizedBox(width: 10),
          Flexible(
            child: _buildCuadro("Ganancias:", ganancias, Colors.lightBlue),
          ),
          SizedBox(width: 10),
          Flexible(
            child: _buildCuadro("Mejor Cliente:", mejorCliente, Colors.lightBlueAccent),
          ),
          SizedBox(width: 10),
        ],
      ),
    ],
  );
}

Widget _buildCuadro(String titulo, String valor, Color color) {
  return Container(
    height: 90,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          offset: Offset(0, 3),
          blurRadius: 6,
        ),
      ],
    ),
    child: Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible( // Permite que el título ocupe varias líneas
            child: Text(
              titulo,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 5),
          Text(
            valor,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}}