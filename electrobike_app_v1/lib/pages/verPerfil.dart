import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa la librería shared_preferences
import '../controllers/controllerUsuario.dart';
import '../models/modeloVerPerfil.dart';

const azul = 0xFF118dd5;

class VerPerfil extends StatefulWidget {
  @override
  _VerPerfilState createState() => _VerPerfilState();
}

class _VerPerfilState extends State<VerPerfil> {
  final _formKey = GlobalKey<FormState>();
  VerPerfilModel? _user;
  bool _isLoading = true;
  final _userController = UserController();
  TextEditingController nombreUsuarioController = TextEditingController();
  TextEditingController tipoDocumentoController = TextEditingController();
  TextEditingController documentoUsuarioController = TextEditingController();
  TextEditingController correoUsuarioController = TextEditingController();
  TextEditingController contrasenaUsuarioController = TextEditingController();
  TextEditingController contrasena2UsuarioController = TextEditingController();
  TextEditingController estadoUsuarioController = TextEditingController();
  TextEditingController idRolController = TextEditingController();

  List<Map<String, dynamic>> _getTipoDocumentoItems() {
    return [
      {
        'value': 'Cc',
        'label': 'Cédula',
      },
      {
        'value': 'Ce',
        'label': 'Cédula extranjera',
      },
      {
        'value': 'Ps',
        'label': 'Pasaporte',
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
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
        nombreUsuarioController.text = _user!.nombreUsuario;
        tipoDocumentoController.text = _user!.tipoDocumentoUsuario!;
        documentoUsuarioController.text = _user!.documentoUsuario!;
        correoUsuarioController.text = _user!.correoUsuario;
        estadoUsuarioController.text = _user!.estadoUsuario;
        contrasenaUsuarioController.text = _user!.contrasenaUsuario!;
        contrasena2UsuarioController.text = _user!.contrasenaUsuario!;
        idRolController.text = _user!.idRol.toString();
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
          )),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _user != null
              ? SingleChildScrollView(
                  child: _buildProfileForm(),
                )
              : Center(
                  child: Text('Usuario no encontrado'),
                ),
    );
  }

  Widget _buildProfileForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Actualizar perfil',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30.0),
          Form(
            key: _formKey,
            child: Column(children: [
              //========================= INPUT NOMBRE USUARIO =================================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: TextFormField(
                  controller: nombreUsuarioController,
                  // initialValue: _user!.nombreUsuario,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Ingrese el nombre del usuario',
                    labelText: 'Nombre',
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
              SizedBox(height: 20.0), // Espacio entre los campos del formulario
              //========================= SELECT TIPO DOCUMENTO =================================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: SelectFormField(
                  // initialValue: _user!.tipoDocumentoUsuario,
                  items: _getTipoDocumentoItems(),
                  controller: tipoDocumentoController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Seleccione el tipo de documento',
                    labelText: 'Tipo de documento',
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
              SizedBox(height: 20.0),
              //========================= INPUT DOCUMENTO USUARIO =================================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: TextFormField(
                  // initialValue: _user!.documentoUsuario,
                  controller: documentoUsuarioController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Ingrese el documento del usuario',
                    labelText: 'Numero de documento',
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
              SizedBox(height: 20.0),
              //========================= INPUT CORREO USUARIO =================================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: TextFormField(
                  // initialValue: _user!.correoUsuario,
                  controller: correoUsuarioController,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(
                        0xFFd6d6d6), // Establecer el color de fondo para que coincida con un campo deshabilitado;
                    labelText: 'Correo electronico',
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
              SizedBox(height: 20.0),
              //========================= INPUT NOMBRE ROL DEL USUARIO =================================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: TextFormField(
                  // initialValue: _user!.nombreRol,
                  readOnly: true, // Deshabilitar el campo de entrada
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(
                        0xFFd6d6d6), // Establecer el color de fondo para que coincida con un campo deshabilitado;
                    labelText: 'Rol',
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
              SizedBox(height: 20.0),
              //========================= INPUT ESTADO USUARIO =================================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: TextFormField(
                  // initialValue: _user!.estadoUsuario,
                  controller: estadoUsuarioController,
                  readOnly: true, // Deshabilitar el campo de entrada
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(
                        0xFFd6d6d6), // Establecer el color de fondo para que coincida con un campo deshabilitado;
                    labelText: 'Estado del usuario',
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
              SizedBox(height: 20.0),
              //========================= INPUT CONTRASEÑA USUARIO =================================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: TextFormField(
                  // initialValue: _user!.contrasenaUsuario,
                  controller: contrasenaUsuarioController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
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
              SizedBox(height: 20.0),
              //========================= INPUT CONFIRMAR CONTRASEÑA USUARIO =================================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: TextFormField(
                  // initialValue: _user!.contrasenaUsuario,
                  controller: contrasena2UsuarioController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
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
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200.0, 50),
                    elevation: 20.0,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      int idRol = int.tryParse(idRolController.text) ?? 0;
                      Map<String, dynamic> data = {
                        'nombreUsuario': nombreUsuarioController.text.trim(),
                        'tipoDocumentoUsuario':tipoDocumentoController.text.trim(),
                        'documentoUsuario':documentoUsuarioController.text.trim(),
                        'correoUsuario': correoUsuarioController.text.trim(),
                        'contrasenaUsuario':contrasenaUsuarioController.text.trim(),
                        'estadoUsuario': estadoUsuarioController.text.trim(),
                        'idRol': idRol,
                      };

                      // Llamar al método para actualizar el perfil en la API
                        await UserController().actualizarPerfil(_user!.idUsuario, data);
                        Navigator.of(context).pop();
                    }
                  },
                  child: Text('Save'),
                ),
              ),
              SizedBox(height: 60.0),
            ]),
          ),
        ],
      ),
    );
  }
}
