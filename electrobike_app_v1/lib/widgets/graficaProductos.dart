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
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
    ];

    return PieChart(
      PieChartData(
        sections: _chartData.map((item) {
          int index = _chartData.indexOf(item) % colors.length;
          return PieChartSectionData(
            title: item['categoriaProducto'],
            value: item['cantidad'].toDouble(),
            color: colors[index],
            radius: 60,
            titleStyle: TextStyle(fontSize: 16),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: _chartData.isNotEmpty
          ? _buildPieChart()
          : CircularProgressIndicator(),
    );
  }
}
