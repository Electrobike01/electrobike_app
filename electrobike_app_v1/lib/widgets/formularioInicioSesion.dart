import 'package:electrobike_app_v1/pages/home.dart';
import 'package:flutter/material.dart';



class FormularioInicioSesion extends StatelessWidget {
  final azul = 0xFF118dd5;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: Center(
            child: Container(
              width: 100, // Tamaño deseado del círculo
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Fondo blanco para el círculo
              ),
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/img/Logo_electrobike.png',
                    width: 90, // Tamaño deseado de la imagen dentro del círculo
                    height: 90,
                    fit: BoxFit.cover, // Ajustar la imagen para cubrir el círculo
                  ),
                ),
              ),
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
              inputFormEmail(),
              SizedBox(height: 20),
              inputFormContrasena(),
              SizedBox(height: 60),
              ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(azul),
                  minimumSize: Size(120, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text('Iniciar Sesión'),
                onPressed: () {
                  print('inicia sesión');
                  // Navegar a la siguiente página cuando el botón sea presionado
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}


Widget inputFormEmail() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // FORMULARIO LOGIN
      Text('Email'),
      SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 0.5, color: Colors.grey)),
        child: TextFormField(
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
        ),
      )
    ],
  );
}

Widget inputFormContrasena() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // FORMULARIO LOGIN
      Text('Contraseña'),
      SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 0.5, color: Colors.grey)),
        child: TextFormField(
          obscureText: true, // Oculta los caracteres ingresados
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
        ),
      )
    ],
  );
}
