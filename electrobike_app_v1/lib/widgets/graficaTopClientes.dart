import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:electrobike_app_v1/controllers/controllerProductos.dart';

class GraficaTopClientes extends StatefulWidget {
  const GraficaTopClientes({Key? key}) : super(key: key);

  @override
  State<GraficaTopClientes> createState() => _GraficaTopClientesState();
}

class _GraficaTopClientesState extends State<GraficaTopClientes> {
  final ControllerProductos _controller = ControllerProductos();
  List<Map<String, dynamic>> _topClientesData = [];

  @override
  void initState() {
    super.initState();
    _fetchTopClientes(); // Obtener los datos de los 5 mejores clientes
  }

  Future<void> _fetchTopClientes() async {
    List<Map<String, dynamic>> data = await _controller.getTopClientes();
    setState(() {
      _topClientesData = data; // Usar la lista completa de datos
    });
  }

   Widget _buildTopClientesChart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4, // Puedes ajustar el factor según tus necesidades
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0), // Ajustar el margen izquierdo
        child: Column(
          children: [
            Container(
              height: 40, // Altura del título
              alignment: Alignment.center,
              child: Text(
                'Top 5 Clientes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: -50,
                ),
                primaryYAxis: CategoryAxis(),
                series: <BarSeries<Map<String, dynamic>, String>>[
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: _topClientesData,
                    xValueMapper: (data, _) => data['nombreCliente'].toString(),
                    yValueMapper: (data, _) => data['totalCompras'], // Usar la propiedad 'totalCompras'
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTopClientesChart();
  }
}
