import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/models/CollectionCategory.dart';

class NewCollectionCategoryScreen extends StatefulWidget {
  CollectionCategory? category;

  NewCollectionCategoryScreen({this.category});

  @override
  _NewCollectionCategoryScreenState createState() =>
      _NewCollectionCategoryScreenState();
}

class _NewCollectionCategoryScreenState
    extends State<NewCollectionCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  Dio _dio = Dio();
  bool isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isEditing = widget.category != null;
      _nameController.text = widget.category?.name ?? "";
      _descriptionController.text = widget.category?.description ?? "";
      _imageController.text = widget.category?.image ?? "";
    });
  }

  Future<void> submitPayment() async {
    if (_formKey.currentState!.validate()) {
      try {
        var body = {
          'name': _nameController.text,
        };

        if (_descriptionController.text.isNotEmpty) {
          body['description'] = _descriptionController.text;
        }

        if (_imageController.text.isNotEmpty) {
          body['image'] = _imageController.text;
        }

        isEditing
            ? await _dio.put(
                "${API_URL}/collections_categories/${widget.category!.id}",
                data: body)
            : await _dio.post("$API_URL/collections_categories", data: body);

        Navigator.pop(context, true);
      } catch (e) {
        print("Error al enviar los datos: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nueva Categoría de Cobro")),
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
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Imagen'),
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
