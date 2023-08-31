import 'package:electrobike_app_v1/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:electrobike_app_v1/widgets/graficaLineal.dart';
import 'package:electrobike_app_v1/widgets/graficaProductos.dart';
import '../widgets/graficaBarrasTop5Productos.dart';
import '../widgets/recuadrosDashboard.dart';
import '../widgets/graficaTopClientes.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'dart:io';
import 'dart:async';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Variable para controlar el estado de actualización
  bool _isRefreshing = false;

  // Función para manejar la acción de actualización
  Future<void> _handleRefresh() async {
    // Coloca aquí tu lógica de actualización de datos
    // Puedes realizar llamadas a APIs, cargar nuevos datos, etc.
    // Por ejemplo, espera unos segundos simulando una actualización.
    await Future.delayed(Duration(seconds: 2));

    // Cuando la actualización esté completa, actualiza el estado
    setState(() {
      _isRefreshing = false;
    });
  }



    Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Hay conexión a internet
      }
    } on SocketException catch (_) {
      return false; // No hay conexión a internet
    }
    return false; // No hay conexión a internet
  }

  Future<bool> validarCon () async {
     bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      print('No hay internet');
      FlutterToastr.show(
        "Verifique su conexión a internet",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor:  Color(0xFFf27474),
      );
      // Navigator.of(context).pop(false);
      return false;
    }
      return true;


  }

    @override
  void initState() {
    super.initState();
    validarCon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh, // Manejador de la acción de actualización
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(), // Permite desplazarse incluso cuando no hay suficiente contenido
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
                      child: graficaLineal(),
                    ),
                    Container(
                      height: 450,
                      child: graficaProductos(),
                    ),
                    Container(
                      height: 500,
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
      ),
    );
  }
}
