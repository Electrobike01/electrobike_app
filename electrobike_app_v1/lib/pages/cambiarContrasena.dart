import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/controllerUsuario.dart';
import 'dart:io';
import 'dart:async';
import '../models/modeloActualizarContrasena.dart';

const azul = 0xFF118dd5;
const gris = 0xFF1d1d1b;

class cambiarContrasena extends StatefulWidget {
  const cambiarContrasena({super.key});

  @override
  State<cambiarContrasena> createState() => _cambiarContrasenaState();
}

class _cambiarContrasenaState extends State<cambiarContrasena> {
  
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  bool _obscurePassword3 = true;
  TextEditingController contrasenaUsuarioController = TextEditingController();
  TextEditingController nuevaContrasenaUsuarioController =
      TextEditingController();
  TextEditingController confirmContrasenaUsuarioController =
      TextEditingController();
  bool _isLoading = false;
  Timer? _timer;

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

  Future<bool> editarPass(ModeloContrasena modeloContrasena) async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      FlutterToastr.show(
        "Verifique su conexión a internet",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Color(0xFFf27474),
      );
      setState(() {
        _isLoading = false;
      });
      _timer?.cancel();
      return false;
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
    final prefs_ = await SharedPreferences.getInstance();
    int idUsuario = prefs_.getInt('idUsuario') ?? -1;
    String contrasenaActual = contrasenaUsuarioController.text; 

    bool isUnique =
        await UserController().validarContrasena(idUsuario, contrasenaActual);
    if (!isUnique) {
      // Cancelar el temporizador despues
      _timer?.cancel();
      FlutterToastr.show(
        "Error de identidad, no se puede registrar",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor:  Color(0xFFf27474),
      );
      setState(() {
        _isLoading = false;
      });
      return false;
    }
    await UserController().actualizarContrasena(modeloContrasena).then((Success) => {
          FlutterToastr.show("Contraseña actualizada correctamente", context,
              duration: FlutterToastr.lengthLong,
              position: FlutterToastr.bottom,
              backgroundColor:  Color(0xFF56baed),
              ),
          // Cancelar el temporizador despues
          _timer?.cancel(),
          Navigator.pop(context, true)
        });
    setState(() {
      _isLoading = false;
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
        automaticallyImplyLeading:
            true, // Esto hace que se muestre la flecha de retroceso
        title: Text('ELECTROBIKE'),
        toolbarHeight: 65, // Cambiar esta línea al valor deseado (en píxeles)
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
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30.0),
              Text(
                'CAMBIAR CONTRASEÑA',
                style: TextStyle(
                    fontSize: 23,
                    color: Color(gris),
                    fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    //========================= INPUT CONTRASEÑA ACTUAL =================================
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                      child: TextFormField(
                        controller: contrasenaUsuarioController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Este campo es obligatorio";
                          }
                          return null;
                        },
                        obscureText: _obscurePassword1,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword1 = !_obscurePassword1;
                              });
                            },
                            child: Icon(
                              _obscurePassword1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          hintText: 'Ingrese su contraseña actual',
                          labelText: 'Contraseña actual',
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
                    SizedBox(height: 40.0),
                    //========================= INPUT NOMBRE USUARIO =================================
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                      child: TextFormField(
                        controller: nuevaContrasenaUsuarioController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Este campo es obligatorio";
                          } else if (value.length < 8) {
                            return "La contraseña debe tener mas de 8 caracteres";
                          }
                          return null;
                        },
                        obscureText: _obscurePassword2,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword2 = !_obscurePassword2;
                              });
                            },
                            child: Icon(
                              _obscurePassword2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          hintText: 'Ingrese su nueva contraseña',
                          labelText: 'Nueva contraseña',
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
                    SizedBox(height: 10.0),
                    //========================= INPUT NOMBRE USUARIO =================================
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                      child: TextFormField(
                        controller: confirmContrasenaUsuarioController,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Este campo es obligatorio";
                          } else if (value.length < 8) {
                            return "La contraseña debe tener mas de 8 caracteres";
                          }
                          return null;
                        },
                        obscureText: _obscurePassword3,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword3 = !_obscurePassword3;
                              });
                            },
                            child: Icon(
                              _obscurePassword3
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          hintText: 'Confirme su nueva contraseña',
                          labelText: 'Confirmar contraseña',
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
                    SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: _isLoading
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
                                  // print('ContraseñaActual ${contrasenaUsuarioController.text}');
                                  // print('Contraseña nueva ${nuevaContrasenaUsuarioController.text}');
                                  // print('Contraseña nueva 2 ${confirmContrasenaUsuarioController.text}');
                                  if (nuevaContrasenaUsuarioController.text !=
                                      confirmContrasenaUsuarioController.text) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Error de contraseña'),
                                          content: Text(
                                              'Las contraseñas nuevas no coinciden.\n\nVuelve a ingresar'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Aceptar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final idUsuario_ = prefs.getInt('idUsuario');

                                    ModeloContrasena modeloContrasena = ModeloContrasena(
                                        idUsuario: idUsuario_.toString(),
                                        contrasenaUsuario: nuevaContrasenaUsuarioController.text
                                    );
                                    // Map<String, dynamic> data = {
                                    //   'idUsuario': idUsuario,
                                    //   'contrasenaActual': contrasenaUsuarioController.text,
                                    //   'contrasenaNueva': nuevaContrasenaUsuarioController.text,
                                    // };
                                    editarPass(modeloContrasena);
                                  }
                                }
                              },
                              child: Text('Guardar'),
                            ),
                    ),
                    SizedBox(height: 40.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
