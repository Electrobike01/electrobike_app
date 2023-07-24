import 'package:flutter/material.dart';

const gris = 0xFF1d1d1b;
void main() => runApp(const VerPerfil());

class VerPerfil extends StatelessWidget {
  const VerPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(gris),
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
      body: const Center(
        child: Text('Ver perfil '),
      ),
    );
  }
}
