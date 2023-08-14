import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/controllerUsuario.dart';

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

  Future<bool> editarPass(Map<String, dynamic> data) async {
    int idUsuario = data['idUsuario'];
    String contrasenaActual = data['contrasenaActual'];

    bool isUnique =
        await UserController().validarContrasena(idUsuario, contrasenaActual);
    if (!isUnique) {
      FlutterToastr.show(
        "Error de identidad, no se puede registrar",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Colors.red,
      );
      return false;
    }
    await UserController().actualizarContrasena(data).then((Success) => {
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(200.0, 50),
                          // elevation: 20.0,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
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
                              final idUsuario = prefs.getInt('idUsuario') ?? -1;
                              Map<String, dynamic> data = {
                                'idUsuario': idUsuario,
                                'contrasenaActual':
                                    contrasenaUsuarioController.text,
                                'contrasenaNueva':
                                    nuevaContrasenaUsuarioController.text,
                              };
                              editarPass(data);
                            }
                          }
                        },
                        child: Text('Guardar'),
                      ),
                    ),
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
