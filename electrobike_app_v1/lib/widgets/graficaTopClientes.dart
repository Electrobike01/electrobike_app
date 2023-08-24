import 'package:electrobike_app_v1/pages/actualizarPerfil.dart';
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
  DateTime _selectedDate = DateTime.now();

  List<String> _monthNames = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  @override
  void initState() {
    super.initState();
    _fetchTopClientes();
  }

  Future<void> _fetchTopClientes() async {
    List<Map<String, dynamic>> data = await _controller.getTopClientes(
      year: _selectedDate.year,
      month: _selectedDate.month,
    );
    setState(() {
      _topClientesData = data;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    int? selectedYear = _selectedDate.year;
    int? selectedMonth = _selectedDate.month;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona una fecha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: selectedYear,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedYear = newValue;
                  });
                },
                items: List.generate(50, (index) {
                  final year = DateTime.now().year + index;
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  );
                }),
              ),
              SizedBox(height: 10),
              DropdownButton<int>(
                value: selectedMonth,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedMonth = newValue;
                  });
                },
                items: List.generate(12, (index) {
                  final month = index + 1;
                  return DropdownMenuItem<int>(
                    value: month,
                    child:
                        Text(_monthNames[month - 1]), // Using month names here
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (selectedYear != null && selectedMonth != null) {
                  setState(() {
                    _selectedDate = DateTime(selectedYear!, selectedMonth!);
                    _fetchTopClientes();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopClientesChart() {
    return Column(
      children: [
        Container(
          height: 40,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 100),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "${_selectedDate.year}-${_monthNames[_selectedDate.month - 1]}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(labelRotation: -50),
            primaryYAxis: CategoryAxis(),
            series: <BarSeries<Map<String, dynamic>, String>>[
              BarSeries<Map<String, dynamic>, String>(
                dataSource: _topClientesData,
                xValueMapper: (data, _) => data['nombreCliente'].toString(),
                yValueMapper: (data, _) => data['totalCompras'],
                dataLabelSettings: DataLabelSettings(isVisible: true),
                color: Color(azul),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(
                  bottom: 20), // Ajusta el valor según sea necesario
              child: Text(
                'Top 5 clientes', // Título de la gráfica
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: _buildTopClientesChart(),
          ),
        ],
      ),
    );
  }
}
