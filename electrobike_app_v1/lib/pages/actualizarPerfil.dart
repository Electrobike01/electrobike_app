// ============================ IMPORTACIONES ========================================
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/controllerUsuario.dart';
import '../models/modeloVerPerfil.dart';
import 'package:flutter/services.dart';
// ============================= COLORES ==============================================
const azul = 0xFF118dd5;

class VerPerfil extends StatefulWidget {
  @override
  _VerPerfilState createState() => _VerPerfilState();
}

class _VerPerfilState extends State<VerPerfil> {

// Se crean las variables que se van a usar
  final _formKey = GlobalKey<FormState>();
  VerPerfilModel? _user;
  bool _isLoading = true;

  // Se crean los controladores
  final _userController = UserController();
  TextEditingController nombreUsuarioController = TextEditingController();
  TextEditingController tipoDocumentoController = TextEditingController();
  TextEditingController documentoUsuarioController = TextEditingController();
  TextEditingController correoUsuarioController = TextEditingController();
  TextEditingController estadoUsuarioController = TextEditingController();
  TextEditingController idRolController = TextEditingController();
  TextEditingController nombreRolController = TextEditingController();

  // Options del select
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
    // Se inicializa el metodo
    _loadUserProfile();
  }

  // Metodo para traer los datos del usuarios
  Future<void> _loadUserProfile() async {
    try {
      // Obtener el ID del usuario desde shared_preferences
      final prefs = await SharedPreferences.getInstance();
      final idUsuario = prefs.getInt('idUsuario') ?? -1; // Si no hay valor en shared_preferences, usar el valor predeterminado -1

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
        nombreRolController.text = _user!.nombreRol!;
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

  Future<bool> editarUser(Map<String, dynamic> data) async {
    
    int idUsuario = data['idUsuario'];
    String documentoUsuario = data['documentoUsuario'];

    bool isUnique = await UserController()
        .validarDocumentoRepetido(idUsuario, documentoUsuario);
    if (!isUnique) {
      FlutterToastr.show(
        "El documento ya fue refgistrado",
        context,
        duration: FlutterToastr.lengthLong,
        position: FlutterToastr.bottom,
        backgroundColor: Colors.red,
      );
      return false;
    }

    await UserController().actualizarPerfil(data).then((Success) => {
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
                  child: Column(children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Color(azul),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(40, 40),
                        bottomRight: Radius.elliptical(40, 40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
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
                  _buildProfileForm(),
                ]))
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,

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
                          BorderSide(width: 3, color: Color(0xFF919191)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, color: Color(0xFF919191)),
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
                  controller: nombreRolController,
                  // initialValue: _user!.nombreRol,
                  readOnly: true, // Deshabilitar el campo de entrada
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(
                        0xFFd6d6d6), // Establecer el color de fondo para que coincida con un campo deshabilitado;
                    labelText: 'Rol',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, color: Color(0xFF919191)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, color: Color(0xFF919191)),
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
                          BorderSide(width: 3, color: Color(0xFF919191)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, color: Color(0xFF919191)),
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

              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200.0, 50),
                    // elevation: 20.0,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (documentoUsuarioController.text.trim().length < 8) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  'El documento debe tener al menos 8 caracteres.'),
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
                        final prefs = await SharedPreferences.getInstance();
                        final idUsuario = prefs.getInt('idUsuario') ?? -1;

                        final idRol = idRolController.text;
                        int idRol_ = int.parse(idRol);
                        
                        Map<String, dynamic> data = {
                          'idUsuario': idUsuario,
                          'nombreUsuario': nombreUsuarioController.text.trim(),
                          'tipoDocumentoUsuario':
                              tipoDocumentoController.text.trim(),
                          'documentoUsuario':
                              documentoUsuarioController.text.trim(),
                          'correoUsuario': correoUsuarioController.text.trim(),
                          'estadoUsuario': estadoUsuarioController.text.trim(),
                          'idRol': idRol_,
                        };
                        editarUser(data);
                      }
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
