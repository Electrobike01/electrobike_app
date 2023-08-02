import 'package:electrobike_app_v1/widgets/formularioInicioSesion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/controllerUsuario.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

const azul = 0xFF118dd5;

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailUsuario = TextEditingController();
  TextEditingController passUsuario = TextEditingController();
  final UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // para que se ajuste automaticamente cuando salga el teclado
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(azul),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Color(azul),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(60, 60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(Icons.person, size: 50),
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  Text(
                    'Bienvenido',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Inicie sesión para continuar.',
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 50),

                  // ================ FORMULARIO ================================
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FORMULARIO EMAIL
                        SizedBox(height: 10),
                        TextFormField(
                          controller: emailUsuario,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Este campo es obligatorio";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Email ',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Color(azul)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Color(azul)),
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

                        SizedBox(height: 20),

                        // FORMULARIO CONTRASEÑA
                        TextFormField(
                          controller: passUsuario,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Este campo es obligatorio";
                            }
                            return null;
                          },
                          obscureText:
                              true, // Para ocultar la contraseña mientras se escribe
                          decoration: InputDecoration(
                            hintText: 'Contraseña',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Color(azul)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Color(azul)),
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

                        SizedBox(height: 60),

                        // BOTÓN INICIAR SESIÓN
                        Center(
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(azul),
                              minimumSize: Size(120, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text('Iniciar Sesión'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String email = emailUsuario.text.trim();
                                String password = passUsuario.text.trim();

                                bool success = await _userController.Login(
                                    email, password);

                                if (success) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                } else {
                                  FlutterToastr.show(
                                    "Error al iniciar",
                                    context,
                                    duration: FlutterToastr.lengthLong,
                                    position: FlutterToastr.bottom,
                                    backgroundColor: Colors.red,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
