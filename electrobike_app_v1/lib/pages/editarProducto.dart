import 'package:electrobike_app_v1/controllers/controllerProductos.dart';
import 'package:flutter/material.dart';
import '../models/modeloProductos.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:select_form_field/select_form_field.dart';

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

  // bool?isUnique; 


    Future<bool> editProduct(ModeloProducto modeloProducto) async {
    String idProducto = idProductoController.text;
    String nombreProducto = nombreProductoController.text.trim();
    String categoriaProducto = categoriaProductoController.text.trim();
          
    bool isUnique = await ControllerProductos().ValidarRepetidosActualizar(idProducto, nombreProducto, categoriaProducto);

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

    await ControllerProductos().updateProducto(modeloProducto).then((Success) => {
          FlutterToastr.show("Producto actualizado", context,
              duration: FlutterToastr.lengthLong,
              position: FlutterToastr.bottom,
              backgroundColor: Colors.green),
          Navigator.of(context).pop()
        });

    return true;
  }

  @override
  void initState() {
    if (widget.index != Null) {
      idProductoController.text =  widget.modeloProducto?.idProducto?.toString() ?? '';
      nombreProductoController.text = widget.modeloProducto?.nombreProducto;
      categoriaProductoController.text = widget.modeloProducto?.categoriaProducto;
      cantidadProductoController.text = widget.modeloProducto?.cantidadProducto?.toString() ?? '';
      estadoProductoController.text = widget.modeloProducto?.estadoProducto;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(gris),
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
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
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
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 5.0),
                    child: TextFormField(
                      controller: cantidadProductoController,
                      keyboardType: TextInputType.number,
                      readOnly: true, // Deshabilitar el campo de entrada

                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Este campo es obligatorio";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Ingrese el nombre del producto',
                        labelText: 'Nombre del producto',
                        filled: true,
                        fillColor: Colors.grey[
                            200], // Establecer el color de fondo para que coincida con un campo deshabilitado
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
                      Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 5.0),
                    child: SelectFormField(
                      controller: estadoProductoController,
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
                      items: estado,
                      onChanged: (val) => print(val),
                      onSaved: (val) => print(val),
                    ),
                  ),
                  SizedBox(
                      height:
                          20.0), // Espacio entre el DropdownButtonFormField y el botón
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200.0, 50),
                      elevation: 20.0,
                    ),
                    onPressed: () async {
                      
                      if (_formKey.currentState!.validate()) {
                        ModeloProducto modeloProducto = ModeloProducto(
                          idProducto: idProductoController.text.trim(),
                          nombreProducto: nombreProductoController.text.trim(),
                          cantidadProducto: cantidadProductoController.text.trim(),
                          categoriaProducto: categoriaProductoController.text.trim(),
                          estadoProducto: estadoProductoController.text.trim(),
                        );
                        bool isAdded = await editProduct(modeloProducto);
                        if (isAdded) {
                          nombreProductoController.clear();
                          cantidadProductoController.clear();
                          categoriaProductoController.clear();
                          estadoProductoController.clear();
                        }
                      }
                    },
                    child: Text('Save'),
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
