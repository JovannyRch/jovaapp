import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/models/Customer.dart';
import 'package:toastification/toastification.dart';

class NewClientPage extends StatefulWidget {
  Customer? customer;

  NewClientPage({this.customer});

  @override
  _NewClientPageState createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  Dio _dio = Dio();
  bool isEditing = false;

  initState() {
    super.initState();
    if (widget.customer != null) {
      isEditing = true;
      _nameController.text = widget.customer!.name!;
      _phoneNumberController.text = widget.customer!.phoneNumber!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> submitClient() async {
    if (_formKey.currentState!.validate()) {
      try {
        var data = {
          'name': _nameController.text,
          'phone_number': _phoneNumberController.text,
        };

        var response = isEditing
            ? await _dio.put("${API_URL}/customers/${widget.customer!.id}",
                data: data)
            : await _dio.post("${API_URL}/customers", data: data);

        if (response.statusCode != 201 && response.statusCode != 200) {
          toastification.show(
            context: context,
            title: const Text('Error al registrar el cliente'),
            type: ToastificationType.error,
            style: ToastificationStyle.flatColored,
          );
          return;
        }

        Customer customer = Customer.fromJson(response.data);
        Navigator.pop(context, customer);
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
                child: Text(
                  isEditing ? 'Editar Cliente' : 'Registrar Cliente',
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
