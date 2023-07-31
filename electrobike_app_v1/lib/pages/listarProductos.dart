import 'dart:async';

import 'package:electrobike_app_v1/controllers/controllerProductos.dart';
import 'package:electrobike_app_v1/models/modeloProductos.dart';
import 'package:electrobike_app_v1/pages/editarProducto.dart';
import 'package:electrobike_app_v1/pages/registrarProductos.dart';
import 'package:electrobike_app_v1/widgets/appBar.dart';
import 'package:flutter/material.dart';

class ListarProductos extends StatefulWidget {
  const ListarProductos({super.key});

  @override
  State<ListarProductos> createState() => _ListarProductosState();
}

class _ListarProductosState extends State<ListarProductos> {
  List<ModeloProducto> listaProductos = [];

  StreamController _streamController = StreamController();

  Future getAllProducts() async {
    listaProductos = await ControllerProductos().getProductos();
    _streamController.sink.add(listaProductos);
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      getAllProducts();
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(
        child: StreamBuilder(
          stream: _streamController.stream,
          builder: (context, snapshots) {
            if (snapshots.hasData) {
              return ListView.builder(
                itemCount: listaProductos.length,
                itemBuilder: ((context, index) {
                  ModeloProducto producto = listaProductos[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5.0,
                      child: ListTile(
                        // leading: CircleAvatar(child: Text(producto.nombreProducto[0]),),
                        title: Text(
                          producto.nombreProducto,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              producto.categoriaProducto,
                              style: TextStyle(color: Colors.blue),
                            ),
                            Text(
                              'Cantidad: ${producto.cantidadProducto}',
                              style: TextStyle(color: Colors.blue),
                            ),
                            Text(
                              'Estado: ${producto.estadoProducto}',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ActualizarProducto(
                                    modeloProducto: producto,
                                    index: index
                                  )),
                            );
                            print('Actualizar');
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Color(azul),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(bottom: 85.0), // Ajusta la distancia aquí
        child: FloatingActionButton(
          onPressed: () {
            // Acción cuando se presiona el FAB
            // Aquí puedes abrir la pantalla para registrar nuevos productos
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrarProductos()),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}