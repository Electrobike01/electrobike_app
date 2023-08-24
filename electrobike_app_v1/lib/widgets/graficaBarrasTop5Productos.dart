import 'package:electrobike_app_v1/pages/actualizarPerfil.dart';
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
    _fetchTopProductosVendidos(); // Llamamos a la función para obtener los datos
  }

  // Función para obtener los productos más vendidos
  Future<void> _fetchTopProductosVendidos() async {
    List<Map<String, dynamic>> data = await _controller.getTopProductos(
      year: _selectedDate.year,
      month: _selectedDate.month,
    );
    setState(() {
      _topProductosData = data;
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
                    _fetchTopProductosVendidos();
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

  // Método para crear la gráfica de barras
  Widget _buildTopProductosVendidosChart() {
    return Column(
      children: [
        Container(
          height: 40,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 120),
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
      body: ListView(physics: NeverScrollableScrollPhysics(), children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(
                bottom: 25,
                top: 20), // Ajusta el valor según sea necesario
            child: Center(
              child: Text(
                'Top 5 productos mas vendidos', // Título de la gráfica
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                  textAlign: TextAlign.center, 
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 350,
          child: _buildTopProductosVendidosChart(),
        ),
      ]),
    );
  }
}
