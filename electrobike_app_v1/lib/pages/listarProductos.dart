import 'dart:async';
import 'package:electrobike_app_v1/controllers/controllerProductos.dart';
import 'package:electrobike_app_v1/models/modeloProductos.dart';
import 'package:electrobike_app_v1/pages/editarProducto.dart';
import 'package:electrobike_app_v1/pages/registrarProductos.dart';
import 'package:electrobike_app_v1/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_toastr/flutter_toastr.dart';

class ListarProductos extends StatefulWidget {
  const ListarProductos({Key? key}) : super(key: key);

  @override
  _ListarProductosState createState() => _ListarProductosState();
}

class _ListarProductosState extends State<ListarProductos> {
  List<ModeloProducto> listaProductos = [];
  List<ModeloProducto> filteredList = [];
  String _searchText = "";
  bool isLoading = false;
  Timer? _timer;
  bool isEditing = false;

  ValueNotifier<List<ModeloProducto>> _filteredListNotifier =
      ValueNotifier<List<ModeloProducto>>([]);

  Timer? _debounceTimer;
  bool _isLoading = true;

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

  Future<void> getAllProducts() async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      FlutterToastr.show(
        "Verifique su conexión a internet",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor:  Color(0xFFf27474),
      );
    }

    // Iniciar el temporizador durante una duración fija
    _timer = Timer(Duration(seconds: 30), () {
      FlutterToastr.show(
        "Tiempo de espera agotado",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Color(0xFFf27474),
      );
      setState(() {
        _isLoading = false;
      });
    });
    listaProductos = await ControllerProductos().getProductos();
    applyFilter(_searchText);
    setState(() {
      _timer?.cancel();
      _isLoading = false;
    });
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
    _timer?.cancel();
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
            if (isEditing)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: getAllProducts,
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
                                  horizontal: 17.0, vertical: 5.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      producto.nombreProducto,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        // color: Color(),
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          producto.categoriaProducto,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Text(
                                          'Cantidad: ${producto.cantidadProducto}',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: <TextSpan>[
                                              TextSpan(text: 'Estado: '),
                                              TextSpan(
                                                text:
                                                    '${producto.estadoProducto}',
                                                style: TextStyle(
                                                  color: producto.estadoProducto ==
                                                              'Activo'
                                                          ? Colors.green
                                                          : Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
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
              ),
          ],
        ),
      ),
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

  Future<void> openEditPage(
      BuildContext context, ModeloProducto producto, int index) async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      FlutterToastr.show(
        "Verifique su conexión a internet",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Color(0xFFf27474),
      );
    } else {
      setState(() {
        isEditing = true;
      });

      var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ActualizarProducto(modeloProducto: producto, index: index),
        ),
      );

      if (result == true) {
        getAllProducts();
      }
      setState(() {
        isEditing = false;
      });
    }
  }
}
