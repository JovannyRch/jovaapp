import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/models/BillCategory.dart';

class NewBillCategoryScreen extends StatefulWidget {
  BillCategory? category;

  NewBillCategoryScreen({this.category});

  @override
  _NewBillCategoryScreenState createState() => _NewBillCategoryScreenState();
}

class _NewBillCategoryScreenState extends State<NewBillCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  Dio _dio = Dio();
  bool isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _openCustomerScreen();
  }

  void _openCustomerScreen() async {
    setState(() {
      isEditing = widget.category != null;
      _nameController.text = widget.category?.name ?? "";
    });
  }

  Future<void> submitPayment() async {
    if (_formKey.currentState!.validate()) {
      try {
        var body = {
          'name': _nameController.text,
        };

        isEditing
            ? await _dio.put(
                "${API_URL}/bill_categories/${widget.category!.id}",
                data: body)
            : await _dio.post("$API_URL/bill_categories", data: body);

        Navigator.pop(context);
      } catch (e) {
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
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: submitPayment,
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
