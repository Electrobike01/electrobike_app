import 'package:electrobike_app_v1/controllers/controllerProductos.dart';
import 'package:flutter/material.dart';
import '../models/modeloProductos.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:select_form_field/select_form_field.dart';

import 'listarProductos.dart';

const gris = 0xFF1d1d1b;

class ActualizarProducto extends StatefulWidget {
  final ModeloProducto? modeloProducto;
  final index;

  const ActualizarProducto({this.modeloProducto, this.index});

  @override
  State<ActualizarProducto> createState() => _ActualizarProductoState();
}

class _ActualizarProductoState extends State<ActualizarProducto> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController idProductoController = TextEditingController();
  TextEditingController nombreProductoController = TextEditingController();
  TextEditingController cantidadProductoController = TextEditingController();
  TextEditingController categoriaProductoController = TextEditingController();
  TextEditingController estadoProductoController = TextEditingController();
  int cantidadProducto = 0;
  bool mostrarBotonEliminar = false;

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

  final List<Map<String, dynamic>> estado = [
    {
      'value': 'Activo',
      'label': 'Activo',
    },
    {
      'value': 'Inactivo',
      'label': 'Inactivo',
    }
  ];

  @override
  void initState() {
    if (widget.index != Null) {
      idProductoController.text =
          widget.modeloProducto?.idProducto?.toString() ?? '';
      nombreProductoController.text = widget.modeloProducto?.nombreProducto;
      categoriaProductoController.text =
          widget.modeloProducto?.categoriaProducto;
      cantidadProductoController.text =
          widget.modeloProducto?.cantidadProducto?.toString() ?? '';
      cantidadProducto =
          int.parse(widget.modeloProducto?.cantidadProducto?.toString() ?? '0');
      estadoProductoController.text = widget.modeloProducto?.estadoProducto;
    }
    validarEliminar();
    super.initState();
  }
Future<bool> eliminarProducto() async {
  int idProducto = int.parse(widget.modeloProducto?.idProducto?.toString() ?? '');

  bool eliminarConfirmado = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmación de eliminación'),
        content: Text('¿Estás seguro que deseas eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () {
              // Acción al presionar el botón "Cancelar"
              Navigator.of(context).pop(false);
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Acción al presionar el botón "Eliminar"
              Navigator.of(context).pop(true);
            },
            child: Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    },
  );

  if (eliminarConfirmado) {
    bool eliminado = await ControllerProductos().eliminarProducto(idProducto);

    if (eliminado) {
      FlutterToastr.show(
        "Producto Eliminado",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Color.fromARGB(255, 206, 233, 207),
      );
      Navigator.pop(context, true);
    }
  }

  return false;
}

  Future<bool> validarEliminar() async {
    int idProducto =
        int.parse(widget.modeloProducto?.idProducto?.toString() ?? '');
    // print(idProducto);
    bool isExist = await ControllerProductos().ValidarEliminar(idProducto);
    print(isExist);

    if (isExist != false) {
      return true;
    }
    return false;
  }

  Future<bool> editProduct(ModeloProducto modeloProducto) async {
    String idProducto = idProductoController.text;
    String nombreProducto = nombreProductoController.text.trim();
    String categoriaProducto = categoriaProductoController.text.trim();

    bool isUnique = await ControllerProductos().ValidarRepetidosActualizar(
        idProducto, nombreProducto, categoriaProducto);

    if (!isUnique) {
      FlutterToastr.show(
        "El producto ya existe",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Colors.red,
      );
      return false;
    }

    await ControllerProductos()
        .updateProducto(modeloProducto)
        .then((Success) => {
              FlutterToastr.show("Producto actualizado", context,
                  duration: FlutterToastr.lengthLong,
                  position: FlutterToastr.bottom,
                  backgroundColor: Color.fromARGB(255, 206, 233, 207)),
              Navigator.pop(context, true)
            });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: validarEliminar(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera el resultado
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF118dd5),
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
                        'Actualizar Producto',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 30.0),
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
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.blueAccent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.blueAccent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //     height: 10.0), // Espacio entre los campos del formulario
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
                                hintText:
                                    'Seleccione la categoría del producto',
                                labelText: 'Categoría del producto',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.blueAccent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.blueAccent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.red),
                                ),
                              ),
                              items: _items,
                              onChanged: (val) => print(val),
                              onSaved: (val) => print(val),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 5.0),
                            child: TextFormField(
                              controller: cantidadProductoController,
                              keyboardType: TextInputType.number,
                              readOnly:
                                  true, // Deshabilitar el campo de entrada

                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Este campo es obligatorio";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Cantidad del producto',
                                filled: true,
                                fillColor: Color(
                                    0xFFd6d6d6), // Establecer el color de fondo para que coincida con un campo deshabilitado;
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.blueAccent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.blueAccent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 5.0),
                            child: SelectFormField(
                              controller: estadoProductoController,
                              readOnly: cantidadProducto > 0,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor seleccione el estado del producto';
                                }
                                return null;
                              },
                              type: SelectFormFieldType.dropdown,
                              decoration: InputDecoration(
                                filled: cantidadProducto > 0,
                                fillColor: Color(0xFFd6d6d6),
                                hintText: 'Seleccione el estado del producto',
                                labelText: 'Estado del producto',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.blueAccent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.blueAccent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.red),
                                ),
                              ),
                              items: estado,
                              onChanged: (val) => print(val),
                              onSaved: (val) => print(val),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(200.0, 50),
                              elevation: 20.0,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                ModeloProducto modeloProducto = ModeloProducto(
                                  idProducto: idProductoController.text.trim(),
                                  nombreProducto:
                                      nombreProductoController.text.trim(),
                                  cantidadProducto:
                                      cantidadProductoController.text.trim(),
                                  categoriaProducto:
                                      categoriaProductoController.text.trim(),
                                  estadoProducto:
                                      estadoProductoController.text.trim(),
                                );
                                bool isAdded =
                                    await editProduct(modeloProducto);
                                if (isAdded) {
                                  nombreProductoController.clear();
                                  cantidadProductoController.clear();
                                  categoriaProductoController.clear();
                                  estadoProductoController.clear();
                                }
                              }
                            },
                            child: Text('Guardar'),
                          ),
                          SizedBox(height: 20.0),
                          if (snapshot.data == true)
                            // SizedBox(height:20.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(200.0, 50),
                                  elevation: 20.0,
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                eliminarProducto();
                                // Aquí va la lógica para eliminar
                              },
                              child: Text('Eliminar'),
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
      },
    );
  }
}
