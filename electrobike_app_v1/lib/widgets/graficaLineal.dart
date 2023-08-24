import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:electrobike_app_v1/controllers/controllerProductos.dart';

class graficaLineal extends StatefulWidget {
  const graficaLineal({super.key});

  @override
  State<graficaLineal> createState() => graficaLinealState();
}

class graficaLinealState extends State<graficaLineal> {
  final ControllerProductos _controller = ControllerProductos();
  List<Map<String, dynamic>> _chartData = [];
  int _selectedYear = DateTime.now().year;
  List<int> _availableYears = [];

  // Lista con los nombres de los meses
  final List<String> _monthLabels = [
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
    _fetchChartData();
  }

  // Obtener los datos de la gráfica desde el backend
  Future<void> _fetchChartData() async {
    Map<String, dynamic>? data = await _controller.getComprasYVentasPorMes();
    if (data == null) {
      return; // Salir si no se obtuvieron datos válidos
    }

    List<dynamic> comprasData = data['compras'];
    List<dynamic> ventasData = data['ventas'];

    // Convertir las listas a List<Map<String, dynamic>>
    List<Map<String, dynamic>> comprasList =
        List<Map<String, dynamic>>.from(comprasData);
    List<Map<String, dynamic>> ventasList =
        List<Map<String, dynamic>>.from(ventasData);

    // Llamar a la función para obtener los años únicos
    _getUniqueYears(comprasList, ventasList);

    // Filtrar los datos por el año seleccionado
    int selectedYear = _selectedYear;

    comprasList =
        comprasList.where((compra) => compra['anio'] == selectedYear).toList();

    ventasList =
        ventasList.where((venta) => venta['anio'] == selectedYear).toList();

    // Crear un mapa para almacenar las compras y ventas por mes
    Map<int, Map<String, dynamic>> chartDataMap = {};

    // Agregar las compras al mapa
    for (var compra in comprasList) {
      int? mes = compra['mes'];
      if (mes != null) {
        chartDataMap[mes] = {
          'mes': mes,
          'compras': compra['total'],
          'ventas': 0,
        };
      }
    }

    // Agregar las ventas al mapa o actualizar el valor si el mes ya existe
    for (var venta in ventasList) {
      int? mes = venta['mes'];
      if (mes != null) {
        if (chartDataMap.containsKey(mes)) {
          chartDataMap[mes]!['ventas'] = venta['total'];
        } else {
          chartDataMap[mes] = {
            'mes': mes,
            'compras': 0,
            'ventas': venta['total'],
          };
        }
      }
    }

    // Obtener los meses ordenados
    List<int> sortedMonths = chartDataMap.keys.toList()..sort();

    // Crear la lista de datos ordenada por los meses
    List<Map<String, dynamic>> sortedChartData = sortedMonths
        .map((mes) => chartDataMap[mes])
        .toList()
        .map((data) => {
              'mes': _monthLabels[data!['mes'] - 1],
              'compras': data['compras'],
              'ventas': data['ventas'],
            })
        .toList();

    setState(() {
      _chartData = sortedChartData;
    });
  }

  // Método para crear el gráfico lineal
  Widget _buildLineChart() {
    return Container(
      width: double.infinity, 
      height: 300, 
      child: Column(
        children: [
          Expanded(
            child: SfCartesianChart(
              // Título del gráfico
              primaryXAxis: CategoryAxis(
                // Título del eje X con los nombres de los meses
                labelIntersectAction: AxisLabelIntersectAction.multipleRows,
                labelRotation:
                    -95, // Rotar las etiquetas para evitar superposiciones
              ), // Eje X con ajustes para mostrar las etiquetas correctamente
              primaryYAxis:
                  NumericAxis(), // Eje Y con valores numéricos (total de compras y ventas)
              series: <LineSeries<Map<String, dynamic>, String>>[
                LineSeries<Map<String, dynamic>, String>(
                    dataSource: _chartData,
                    xValueMapper: (data, _) => data['mes'],
                    yValueMapper: (data, _) => data['compras'],
                    name: 'Compras',
                    color: Color(0xFF118dd5)),
                LineSeries<Map<String, dynamic>, String>(
                    dataSource: _chartData,
                    xValueMapper: (data, _) => data['mes'],
                    yValueMapper: (data, _) => data['ventas'],
                    name: 'Ventas',
                    color: Color(0xFF81d3eb)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 15,
                color: Color(0xFF81d3eb),
              ),
              SizedBox(width: 5),
              Text(
                'Compras',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(width: 20),
              Container(
                width: 20,
                height: 15,
                color: Color(0xFF118dd5),
              ),
              SizedBox(width: 10),
              Text(
                'Ventas',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Función para obtener el año desde el número de mes
  int _getYearFromMonth(int month) {
    int currentYear = DateTime.now().year;
    int currentMonth = DateTime.now().month;

    if (month <= currentMonth) {
      return currentYear;
    } else {
      return currentYear - 1;
    }
  }

  // Método para crear el selector de año
  Widget _buildYearSelector() {
    return DropdownButton<int>(

      
      
      value: _selectedYear,
      items: _getYearItems(), // Retorna los elementos del selector
      onChanged: (year) {
        setState(() {
          _selectedYear = year!;
        });
        _fetchChartData(); // Vuelve a obtener los datos para el nuevo año
      },

      
    );
  }

  // Función para obtener los años únicos de las listas de compras y ventas
  void _getUniqueYears(List<Map<String, dynamic>> comprasList,
      List<Map<String, dynamic>> ventasList) {
    _availableYears = [];

    for (var compra in comprasList) {
      int? anio = compra['anio'];
      if (anio != null && !_availableYears.contains(anio)) {
        _availableYears.add(anio);
      }
    }

    for (var venta in ventasList) {
      int? anio = venta['anio'];
      if (anio != null && !_availableYears.contains(anio)) {
        _availableYears.add(anio);
      }
    }
  }

  // Método para obtener la lista de elementos del selector de año
  List<DropdownMenuItem<int>> _getYearItems() {
    // Ordenar la lista de años de forma descendente
    _availableYears.sort((a, b) => b.compareTo(a));

    List<DropdownMenuItem<int>> yearItems = [];
    for (int year in _availableYears) {
      yearItems.add(
        DropdownMenuItem<int>(
          value: year,
          child: Text(year.toString()),
        ),
      );
    }

    return yearItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: NeverScrollableScrollPhysics(), // Desactiva el scroll
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Compras y ventas', // Título de la gráfica
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.end, // Alineación a la derecha
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: _buildYearSelector(),
              ),
            ],
          ),
          SizedBox(
            width: double.maxFinite,
            height: 300,
            child: _buildLineChart(),
          ),
        ],
      ),
    );
  }
}
