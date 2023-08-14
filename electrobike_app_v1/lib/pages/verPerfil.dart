import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa la librería shared_preferences
import '../controllers/controllerUsuario.dart';
import '../models/modeloVerPerfil.dart';
import '../widgets/appBar.dart';
import 'Login.dart';
import 'actualizarPerfil.dart';
import 'cambiarContrasena.dart';

const azul = 0xFF118dd5;
const gris = 0xFF1d1d1b;

class infoPerfil extends StatefulWidget {
  const infoPerfil({super.key});

  @override
  State<infoPerfil> createState() => infoPerfilState();
}

class infoPerfilState extends State<infoPerfil> {
  VerPerfilModel? _user;
  bool _isLoading = true;
  final _userController = UserController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> getId() async {
    // Obtener el ID del usuario desde shared_preferences
    final prefs = await SharedPreferences.getInstance();
    final idUsuario = prefs.getInt('idUsuario') ??
        1; // Si no hay valor en shared_preferences, usar el valor predeterminado 1
  }

  Future<void> _loadUserProfile() async {
    try {
      // Obtener el ID del usuario desde shared_preferences
      final prefs = await SharedPreferences.getInstance();
      final idUsuario = prefs.getInt('idUsuario') ??
          1; // Si no hay valor en shared_preferences, usar el valor predeterminado 1

      final user = await _userController.getUserProfile(idUsuario);
      setState(() {
        _user = user;
        _isLoading = false;

        // Cargar los controladores con los valores del usuario
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar Sesión'),
          content: Text('¿Estás seguro que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
            TextButton(
              child: Text('Cerrar Sesión'),
              onPressed: () async {
                await _userController.destroySession();
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(azul),
          automaticallyImplyLeading:
              true, // Esto evita que se muestre la flecha de retroceso
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
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(azul),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(60, 60),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20.0, top: 20, left: 10),
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola! \n${_isLoading ? 'Cargando...' : (_user?.nombreUsuario ?? '')}',
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          '${_isLoading ? 'Cargando...' : (_user?.correoUsuario ?? '')}',
                          style: TextStyle(fontSize: 19, color: Colors.white),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
              SizedBox(height: 90.0),
              Text(
                'Opciones de usuario',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Color(gris)),
              ),
              SizedBox(height: 140.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200.0, 50),
                    backgroundColor: Color(azul),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Bordes redondeados
                      side: BorderSide(color: Colors.blue), // Borde azul
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VerPerfil()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.edit), // Agregar el icono aquí
                      SizedBox(width: 15), // Espacio entre el icono y el texto
                      Text('Actualizar perfil'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200.0, 50),
                    backgroundColor: Color(azul),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Bordes redondeados
                      side: BorderSide(color: Colors.blue), // Borde azul
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => cambiarContrasena()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.vpn_key), // Agregar el icono aquí
                      SizedBox(width: 10), // Espacio entre el icono y el texto
                      Text('Cambiar contraseña'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 80.0),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 80.0),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       fixedSize: Size(200.0, 50),
              //       backgroundColor: Color(gris),
              //       elevation: 0,
              //       shape: RoundedRectangleBorder(
              //         borderRadius:
              //             BorderRadius.circular(10.0), // Bordes redondeados
              //         side: BorderSide(color: Color(gris)), // Borde azul
              //       ),
              //     ),
              //     onPressed: () async {
              //       _showLogoutConfirmationDialog(
              //           context); // Llama al método para mostrar la alerta
              //     },
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Icon(Icons.logout), // Agregar el icono aquí
              //         SizedBox(width: 30), // Espacio entre el icono y el texto
              //         Text('Cerrar sesion'),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
