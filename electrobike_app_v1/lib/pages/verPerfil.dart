import 'package:flutter/material.dart';

void main() => runApp(const VerPerfil());

class VerPerfil extends StatelessWidget {
  const VerPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Ver perfil '),
        ),
      ),
    );
  }
}