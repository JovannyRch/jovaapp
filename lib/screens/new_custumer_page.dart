import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jova_app/api/api.dart';

class NewClientPage extends StatefulWidget {
  @override
  _NewClientPageState createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  Dio _dio = Dio();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> submitClient() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _dio.post("$API_URL/customers", data: {
          'name': _nameController.text,
          'phone_number': _phoneNumberController.text
        });
        Navigator.pop(context); // Regresar a la pantalla anterior si es exitoso
      } catch (e) {
        print("Error al enviar los datos: $e");
        // Mostrar un mensaje de error o dialog aquí
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nuevo Cliente")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el nombre del cliente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número de Teléfono',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el número de teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitClient,
                child: const Text(
                  'Guardar',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}