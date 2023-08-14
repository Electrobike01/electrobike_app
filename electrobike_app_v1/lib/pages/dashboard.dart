import 'package:electrobike_app_v1/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:electrobike_app_v1/controllers/controllerProductos.dart';
import 'package:electrobike_app_v1/widgets/graficaLineal.dart';
import 'package:electrobike_app_v1/widgets/graficaProductos.dart';
import '../widgets/graficaProductos.dart';
import '../widgets/graficaBarrasTop5Productos.dart';
import '../widgets/recuadrosDashboard.dart';
import '../widgets/graficaTopClientes.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: Column(
                children: [
                  Container(
                    height: 450,
                    child: graficaProductos(),
                  ),
                  Container(
                    height: 450,
                    child: graficaLineal(),
                  ),
                  Container(
                    height: 350,
                    child: GraficaBarrasP(),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 50.0)),
                  Container(
                    height: 350,
                    child: GraficaTopClientes(),
                  )
                ],
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
            ),
          ],
        ),
      ),
    );
  }
}
