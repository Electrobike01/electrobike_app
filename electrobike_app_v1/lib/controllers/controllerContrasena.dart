import 'dart:convert';
import 'package:http/http.dart' as http;

class ControllerContrasena {
  Future<Map<String, dynamic>> recuperarContrasena(String email) async {
    final url = Uri.parse(
      'https://electrobike-adso.000webhostapp.com/apiElectrobike_app/contrasena/recuperarContrasena.php'
      // 'http://192.168.0.4/apiElectrobike_app/contrasena/recuperarContrasena.php'
      
      );
  
    try {
      final response = await http.post(url, body: {'email': email});

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        return responseData;
      } else {
        throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud HTTP: $e');
    }
  }

  Future<Map<String, dynamic>> nuevaContrasena(String email, String nuevaContrasena, String confirmarContrasena) async {
    final url = Uri.parse(
      'https://electrobike-adso.000webhostapp.com/apiElectrobike_app/contrasena/nuevaContrasena.php'
      // 'http://192.168.0.4/apiElectrobike_app/contrasena/nuevaContrasena.php'
    );
  
    try {
      final response = await http.post(url, body: {
        'email': email,
        'nuevaContrasena': nuevaContrasena,
        'confirmarContrasena': confirmarContrasena,
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud HTTP: $e');
    }
  }

   // Validar que el documento no exista al momento de actualizar
  Future<bool> validarCorreoExisten( String correoUsuario) async {
    final response = await http.get(Uri.parse(
        "https://electrobike-adso.000webhostapp.com/apiElectrobike_app/contrasena/validarCorreo.php?correoUsuario=$correoUsuario"
        // "http://192.168.0.4/apiElectrobike_app/contrasena/validarCorreo.php?correoUsuario=$correoUsuario"
        
        ));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['isUnique'];
    } else {
      return false;
    }
  }
}
