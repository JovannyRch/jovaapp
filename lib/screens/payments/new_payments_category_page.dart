import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/models/Customer.dart';
import 'package:jova_app/models/Reponses/PaymentCategoryDetails.dart';
import 'package:jova_app/screens/customers/customers_screen.dart';
import 'package:jova_app/widgets/InfoText.dart';
import 'package:toastification/toastification.dart';

class NewPaymentsCategoryPage extends StatefulWidget {
  PaymentCategoryDetailsResponse? category;

  NewPaymentsCategoryPage({this.category});

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
  bool isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _budgeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _openCustomerScreen();
  }

  void _openCustomerScreen() async {
    isEditing = widget.category != null;

    if (!isEditing) {
      await Future.delayed(Duration.zero);
      customer = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomersScreen()),
      );
    } else {
      print("${widget.category!.customer!.name}");
      customer = widget.category!.customer;
      _nameController.text = widget.category!.name!;
      _budgeController.text = widget.category!.budget.toString();
    }

    setState(() {});
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

        var response = isEditing
            ? await _dio.put(
                "${API_URL}/payments_categories/${widget.category!.id}",
                data: body)
            : await _dio.post("$API_URL/payments_categories", data: body);
        print(response);
        if (response.statusCode == 201 || response.statusCode == 200) {
          Navigator.pop(context, true);
        } else {
          toastification.show(
            context: context,
            title: Text("Error al guardar los datos"),
            type: ToastificationType.error,
            style: ToastificationStyle.flatColored,
          );
        }
      } catch (e) {
        // Mostrar un mensaje de error o dialog aquí
        print("Error al enviar los datos: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(isEditing ? 'Editar Categoría' : 'Nueva Categoría')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (customer != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                              builder: (context) => CustomersScreen()),
                        );
                        if (customer != null) {
                          setState(() {});
                        }
                      },
                      child: const Text(
                        'Cambiar Cliente',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 11.0,
                        ),
                      ),
                    ),
                  ],
                ),
              if (customer == null)
                TextButton(
                  onPressed: () async {
                    customer = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomersScreen()),
                    );
                    if (customer != null) {
                      setState(() {});
                    }
                  },
                  child: const Text(
                    'Selecionar Cliente',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 11.0,
                    ),
                  ),
                ),
              const SizedBox(height: 10.0),
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
                  onPressed: customer == null ? null : submitPayment,
                  child: isEditing
                      ? const Text('Actualizar')
                      : const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
