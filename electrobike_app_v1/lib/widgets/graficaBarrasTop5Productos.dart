import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:electrobike_app_v1/controllers/controllerProductos.dart';

class GraficaBarrasP extends StatefulWidget {
  const GraficaBarrasP({Key? key}) : super(key: key);

  @override
  State<GraficaBarrasP> createState() => _GraficaBarrasState();
}

class _GraficaBarrasState extends State<GraficaBarrasP> {
  final ControllerProductos _controller = ControllerProductos();
  List<Map<String, dynamic>> _topProductosData =
      []; // Lista para datos de productos más vendidos

  @override
  void initState() {
    super.initState();
    _fetchTopProductosVendidos(); // Llamamos a la función para obtener los datos
  }

  // Función para obtener los productos más vendidos
  Future<void> _fetchTopProductosVendidos() async {
    List<Map<String, dynamic>> data = await _controller.getTopProductos();
    setState(() {
      _topProductosData = data;
    });
  }

  // Método para crear la gráfica de barras
  Widget _buildTopProductosVendidosChart() {
    return Container(
      width: 300, // Tamaño horizontal deseado
      height: 80, // Tamaño vertical deseado
      child: SfCartesianChart(
        title: ChartTitle(
          text: 'Top 5 productos',
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        primaryXAxis: CategoryAxis(
          labelRotation: -90,
        ),
        primaryYAxis: NumericAxis(),
        series: <ColumnSeries<Map<String, dynamic>, String>>[
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: _topProductosData,
            xValueMapper: (data, _) => data['nombreProducto'].toString(),
            yValueMapper: (data, _) => int.parse(data['totalVentas']),
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTopProductosVendidosChart(); // Mostrar la gráfica
  }
}
