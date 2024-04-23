import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/models/Customer.dart';
import 'package:jova_app/screens/custumers_screen.dart';
import 'package:jova_app/widgets/InfoText.dart';

class NewPaymentsCategoryPage extends StatefulWidget {
  @override
  _NewPaymentsCategoryPageState createState() =>
      _NewPaymentsCategoryPageState();
}

class _NewPaymentsCategoryPageState extends State<NewPaymentsCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _budgeController = TextEditingController();
  Dio _dio = Dio();
  Customer? customer;

  @override
  void dispose() {
    _nameController.dispose();
    _budgeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> submitPayment() async {
    if (_formKey.currentState!.validate() && customer != null) {
      try {
        var body = {
          'customer_id': customer!.id,
          'name': _nameController.text,
          "budget": 0,
        };

        if (_budgeController.text.isNotEmpty) {
          body['budget'] = double.parse(_budgeController.text);
        }

        var response =
            await _dio.post("$API_URL/payments_categories", data: body);
        print(response.data);
        Navigator.pop(context);
      } catch (e) {
        // Mostrar un mensaje de error o dialog aquí
        print("Error al enviar los datos: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nueva Categoría de Pago")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (customer == null)
                TextButton(
                  onPressed: () async {
                    customer = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustumersScreen()),
                    );
                    setState(() {});
                  },
                  child: const Text('Seleccionar Cliente'),
                ),
              if (customer != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Info(
                      title: "Cliente seleccionado",
                      content: customer!.name!,
                    ),
                    TextButton(
                      onPressed: () async {
                        customer = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustumersScreen()),
                        );
                        setState(() {});
                      },
                      child: Text('Cambiar Cliente'),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration:
                    InputDecoration(labelText: 'Nombre de la categoría'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el nombre del pago';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _budgeController,
                decoration: InputDecoration(labelText: 'Presupuesto'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: submitPayment,
                  child: Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
