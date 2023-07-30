import 'dart:async';
import 'package:flutter/material.dart';
import 'package:electrobike_app_v1/controllers/controllerProductos.dart';
import 'package:electrobike_app_v1/models/modeloProductos.dart';
import 'package:electrobike_app_v1/pages/editarProducto.dart';
import 'package:electrobike_app_v1/pages/registrarProductos.dart';
import 'package:electrobike_app_v1/widgets/appBar.dart';

class ListarProductos extends StatefulWidget {
  const ListarProductos({super.key});

  @override
  State<ListarProductos> createState() => _ListarProductosState();
}

class _ListarProductosState extends State<ListarProductos> {
  late ScrollController _scrollController;
  bool _isVisible = true;

  List<ModeloProducto> listaProductos = [];
  List<ModeloProducto> listaProductosFiltrados = [];

  StreamController<List<ModeloProducto>> _streamController =
      StreamController<List<ModeloProducto>>();

  Future<void> getAllProducts() async {
    listaProductos = await ControllerProductos().getProductos();
    _streamController.sink.add(listaProductos);
  }

  @override
  void initState() {
    getAllProducts();
    super.initState();
    
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _filtrarProductos(String searchTerm) {
    setState(() {
      listaProductosFiltrados = listaProductos.where((producto) {
        // Verificar si alguna de las propiedades del producto contiene el término de búsqueda
        return producto.nombreProducto
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            producto.categoriaProducto
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            producto.cantidadProducto
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            producto.estadoProducto
                .toLowerCase()
                .contains(searchTerm.toLowerCase());
      }).toList();
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => _filtrarProductos(value),
                decoration: InputDecoration(
                  hintText: "Buscar producto",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<ModeloProducto>>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final productosToShow = listaProductosFiltrados.isNotEmpty
                        ? listaProductosFiltrados
                        : listaProductos;

                    return ListView.builder(
                      itemCount: productosToShow.length,
                      itemBuilder: ((context, index) {
                        ModeloProducto producto = productosToShow[index];
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
                                        index: index,
                                      ),
                                    ),
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
          ],
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
