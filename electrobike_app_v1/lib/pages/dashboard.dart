import 'package:electrobike_app_v1/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:electrobike_app_v1/controllers/controllerProductos.dart';

import '../widgets/graficaProductos.dart';
import '../widgets/recuadrosDashboard.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: CuadrosInformativos(),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: Column(
                children: [
                  Text(
                    'TOTAL PRODUCTOS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  graficaProductos(),
                ],
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
