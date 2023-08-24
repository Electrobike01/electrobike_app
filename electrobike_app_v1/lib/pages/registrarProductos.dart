import 'package:electrobike_app_v1/controllers/controllerProductos.dart';
import 'package:electrobike_app_v1/models/modeloProductos.dart';
import 'package:electrobike_app_v1/pages/home.dart';
import 'package:electrobike_app_v1/pages/listarProductos.dart';
import 'package:electrobike_app_v1/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:select_form_field/select_form_field.dart';
import 'dart:io';
import 'dart:async';

const gris = 0xFF1d1d1b;
const azul = 0xFF118dd5;

class RegistrarProductos extends StatefulWidget {
  const RegistrarProductos({super.key});

  @override
  State<RegistrarProductos> createState() => _RegistrarProductosState();
}

class _RegistrarProductosState extends State<RegistrarProductos> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nombreProductoController = TextEditingController();
  TextEditingController categoriaProductoController = TextEditingController();
  Timer? _timer;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Bicicletas alta gama',
      'label': 'Bicicletas alta gama',
    },
    {
      'value': 'Bicicletas baja gama',
      'label': 'Bicicletas baja gama',
    },
    {
      'value': 'Repuestos alta gama',
      'label': 'Repuestos alta gama',
    },
    {
      'value': 'Repuestos baja gama',
      'label': 'Repuestos baja gama',
    },
  ];
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

  Future<bool> AddProduct(ModeloProducto modeloProducto) async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      setState(() {
        _isLoading = false;
      });
      FlutterToastr.show(
        "Verifique su conexión a internet",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Color(0xFFd53b3b),
      );

      return false;
    }

    // Iniciar el temporizador durante una duración fija
    _timer = Timer(Duration(seconds: 30), () {
      FlutterToastr.show(
        "Tiempo de espera agotado",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Color(0xFFd53b3b),
      );
      setState(() {
        _isLoading = false;
      });
    });

    String nombreProducto = nombreProductoController.text.trim();
    String categoriaProducto = categoriaProductoController.text.trim();

    bool isUnique = await ControllerProductos().ValidarProducto(nombreProducto, categoriaProducto);
    _timer?.cancel();

    if (!isUnique) {
      FlutterToastr.show(
        "El producto ya existe",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Colors.red,
      );
      setState(() {
        _isLoading = false;
      });
      return false;
    }

    await ControllerProductos().addProducto(modeloProducto).then((Success) => {
          _timer?.cancel(),
          FlutterToastr.show("Producto registrado", context,
              duration: FlutterToastr.lengthLong,
              position: FlutterToastr.bottom,
              backgroundColor: Colors.green),
          setState(() {
            _isLoading = false;
          }),
          Navigator.of(context).pop()
        });

    return true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(azul),
        automaticallyImplyLeading: true,
        title: Text('ELECTROBIKE'),
        toolbarHeight: 65,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.0),
            Center(
              child: Text(
                'Registrar Producto',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 50.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 5.0),
                    child: TextFormField(
                      controller: nombreProductoController,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Este campo es obligatorio";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Ingrese el nombre del producto',
                        labelText: 'Nombre del producto',
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 3, color: Colors.blueAccent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 3, color: Colors.blueAccent),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 10.0), // Espacio entre los campos del formulario
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 5.0),
                      child: SelectFormField(
                        controller: categoriaProductoController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingrese la categoría del producto';
                          }
                          return null;
                        },
                        type: SelectFormFieldType.dropdown,
                        decoration: InputDecoration(
                          hintText: 'Seleccione la categoría del producto',
                          labelText: 'Categoría del producto',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.blueAccent),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.red),
                          ),
                        ),
                        items: _items,
                        onChanged: (val) => print(val),
                        onSaved: (val) => print(val),
                      )),
                  SizedBox(
                      height:
                          40.0), // Espacio entre el DropdownButtonFormField y el botón
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(200.0, 50),
                            // elevation: 20.0,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              ModeloProducto modeloProducto = ModeloProducto(
                                nombreProducto:
                                    nombreProductoController.text.trim(),
                                categoriaProducto:
                                    categoriaProductoController.text.trim(),
                              );
                              bool isAdded = await AddProduct(modeloProducto);
                              if (isAdded) {
                                nombreProductoController.clear();
                                categoriaProductoController.clear();
                              }
                            }
                          },
                          child: Text('Guardar'),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
