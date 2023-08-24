import 'package:flutter/material.dart';
import 'package:electrobike_app_v1/controllers/controllerProductos.dart';
import 'package:intl/intl.dart';

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

  double parseDouble(String value, {double defaultValue = 0.0}) {
  try {
    return double.parse(value);
  } catch (e) {
    return defaultValue;
  }
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
              child: _buildCuadro("Compras:", totalCompras, Color(0xFF1a7996)),
            ),
            SizedBox(width: 10),
            Flexible(
              child: _buildCuadro("Ventas:", totalVentas, Color(0xFF3aa4c4)),
            ),
            SizedBox(width: 10),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 10),
            Flexible(
              child: _buildCuadro(
                "Ganancias:",
                ganancias,
                 parseDouble(ganancias) >= 0 ? Color(0xFF3aa4c4) : Color(0xFFd53b3b),
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: _buildCuadro(
                  "Mejor Cliente:", mejorCliente, Color(0xFF1a7996)),
            ),
            SizedBox(width: 10),
          ],
        ),
      ],
    );
  }

  Widget _buildCuadro(String titulo, String valor, Color color) {
    // Convertir el valor a un número si es numérico
    double valorNumerico = double.tryParse(valor) ?? double.nan;

    // Verificar si el valor no es un número
    bool isNotANumber = valorNumerico.isNaN;

    // Formatear el valor numérico con separadores de miles y símbolo de moneda al final
    NumberFormat numberFormat = NumberFormat.currency(
      locale: 'es',
      symbol: '\$', // Símbolo de peso al final
      decimalDigits: 0, // Cantidad de dígitos decimales
    );

    // Aplicar formato solo si es un valor numérico, de lo contrario, dejar el texto tal cual
    String valorFormateado =
        isNotANumber ? valor : numberFormat.format(valorNumerico);

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
            Flexible(
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
            Flexible(
              child: Text(
                valorFormateado,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
