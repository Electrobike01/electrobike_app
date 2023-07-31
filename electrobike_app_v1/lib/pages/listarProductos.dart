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
  List<ModeloProducto> filteredList = [];
  String _searchText = "";

  ValueNotifier<List<ModeloProducto>> _filteredListNotifier =
      ValueNotifier<List<ModeloProducto>>([]);

  Timer? _debounceTimer;

  Future<void> getAllProducts() async {
    listaProductos = await ControllerProductos().getProductos();
    applyFilter(_searchText);
  }

 void applyFilter(String searchText) {
  if (searchText.isEmpty) {
    filteredList = List.from(listaProductos);
  } else {
    final searchTerms = searchText.trim().toLowerCase().split(' ');
    filteredList = listaProductos.where((producto) {
      return searchTerms.every((term) {
        return producto.nombreProducto.toLowerCase().contains(term) ||
            producto.categoriaProducto.toLowerCase().contains(term) ||
            producto.estadoProducto.toLowerCase().contains(term) ||
            producto.cantidadProducto.toString().contains(term);
      });
    }).toList();
  }
  _filteredListNotifier.value = filteredList;
}

  @override
  void initState() {
    super.initState();
    getAllProducts();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
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
                onChanged: onSearchTextChanged,
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<ModeloProducto>>(
                valueListenable: _filteredListNotifier,
                builder: (context, filteredList, _) {
                  if (filteredList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: ((context, index) {
                        ModeloProducto producto = filteredList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5.0,
                            child: ListTile(
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
                                  openEditPage(context, producto, index);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  } else {
                    return Center(
                      child: Text('No se encontraron productos.'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 85.0),
        child: FloatingActionButton(
          onPressed: () {
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

  void onSearchTextChanged(String searchText) {
    setState(() {
      _searchText = searchText.trim();
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      applyFilter(searchText.trim());
    });
  }

  Future<void> openEditPage(BuildContext context, ModeloProducto producto, int index) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ActualizarProducto(modeloProducto: producto, index: index)),
    );

    if (result == true) {
      getAllProducts();
    }
  }
}
