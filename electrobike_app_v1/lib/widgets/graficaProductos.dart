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
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 0,
          sections: _chartData.isNotEmpty
              ? _chartData.map((item) {
                  int index = _chartData.indexOf(item) % colors.length;
                  double value = item['cantidad'].toDouble();
                  double total =
                      _chartData.fold(0.0, (sum, item) => sum + item['cantidad']);
                  double percentage = (value / total) * 100;

                  return PieChartSectionData(
                    value: value,
                    color: colors[index],
                    title: '${percentage.toStringAsFixed(2)}%',
                    showTitle: true,
                    titleStyle: TextStyle(fontSize: 12),
                    radius: 100,
                  );
                }).toList()
              : [
                  PieChartSectionData(
                    value: 100,
                    color: Colors.blue,
                    title: 'No hay resultados',
                    showTitle: true,
                    titleStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.0,
                    radius: 100,
                  ),
                ],
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
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final screenHeight = MediaQuery.of(context).size.height;
    final chartHeight = isPortrait ? screenHeight * 0.35 : screenHeight * 0.8;
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
            height: chartHeight,
            padding: const EdgeInsets.all(15),
            child: _buildPieChart(),
          ),
          // Widget de la leyenda
          _buildLegend(),
        ],
      ),
    );
  }
}






