import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:electrobike_app_v1/controllers/controllerProductos.dart';

class graficaProductos extends StatefulWidget {
  const graficaProductos({super.key});

  @override
  State<graficaProductos> createState() => graficaProductosState();
}

class graficaProductosState extends State<graficaProductos> {
  final ControllerProductos _controller = ControllerProductos();
  List<Map<String, dynamic>> _chartData = [];

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  // Obtener los datos de la gráfica desde el backend
  Future<void> _fetchChartData() async {
    List<Map<String, dynamic>> data = await _controller.getChartData();
    setState(() {
      _chartData = data;
    });
  }

  // Método para crear la gráfica de torta
  Widget _buildPieChart() {
    List<Color> colors = [
        Color(0xFF0083cf),
      Color.fromARGB(255, 89, 202, 236),
      Color.fromARGB(255, 14, 153, 199),
      Color.fromARGB(255, 0, 193, 252),
    ];

    return AspectRatio(
      aspectRatio:
          1, // Ajustar la relación de aspecto para hacer la gráfica más grande
      child: PieChart(
        PieChartData(
          centerSpaceRadius:
              0, // Establecer el centro a 0 para eliminar el espacio en blanco
          sections: _chartData.map((item) {
            int index = _chartData.indexOf(item) % colors.length;
            double value = item['cantidad'].toDouble();
            double total =
                _chartData.fold(0.0, (sum, item) => sum + item['cantidad']);
            double percentage = (value / total) * 100;

            return PieChartSectionData(
              value: value,
              color: colors[index],
              title:
                  '${percentage.toStringAsFixed(2)}%', // Mostrar el porcentaje en la gráfica
              showTitle:
                  true, // Mostrar el título (porcentaje) dentro de la gráfica
              titleStyle: TextStyle(fontSize: 12),
              radius: 100, //tamaño de la grafica
            );
          }).toList(),
        ),
      ),
    );
  }

  // Método para crear la leyenda manualmente
  Widget _buildLegend() {
    List<Color> colors = [
     Color(0xFF0083cf),
      Color.fromARGB(255, 89, 202, 236),
      Color.fromARGB(255, 14, 153, 199),
      Color.fromARGB(255, 0, 193, 252),
    ];

    return Container(
      padding: const EdgeInsets.all(0),
      child: Wrap(
        spacing: 30,
        runSpacing: 10,
        children: _chartData.map((item) {
          int index = _chartData.indexOf(item) % colors.length;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                color: colors[index],
              ),
              SizedBox(width: 5),
              Text(item['categoriaProducto']),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
            SizedBox(
            height: 30,
          ),
          Text(
            'Productos en stock',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: _chartData.isNotEmpty
                ? _buildPieChart()
                : CircularProgressIndicator(),
          ),
          // Widget de la leyenda
          _buildLegend(),
        ],
      ),
    );
  }
}
