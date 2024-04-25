import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/models/Collection/CollectionPayment.dart';
import 'package:jova_app/models/CollectionCategory.dart';
import 'package:jova_app/models/Customer.dart';
import 'package:jova_app/widgets/DateInputPicket.dart';
import 'package:toastification/toastification.dart';

class NewCollectionPaymentScreen extends StatefulWidget {
  final CollectionCategory category;
  final Customer customer;

  NewCollectionPaymentScreen({required this.category, required this.customer});

  @override
  _NewCollectionPaymentScreenState createState() =>
      _NewCollectionPaymentScreenState();
}

class _NewCollectionPaymentScreenState
    extends State<NewCollectionPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();
  Dio dio = Dio();

  @override
  initState() {
    super.initState();
    _dateController.text = DateTime.now().toString().substring(0, 10);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final payment = CollectionPayment(
        collectionId: widget.category.id,
        amount: _amountController.text,
        date: _dateController.text,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      _sendPaymentData(payment);
    }
  }

  Future<void> _sendPaymentData(CollectionPayment payment) async {
    try {
      print({
        'collection_id': payment.collectionId,
        'customer_id': widget.customer.id,
        'amount': payment.amount,
        'date': payment.date,
        'notes': payment.notes,
      });

      print("${API_URL}/collections_payments");

      final response = await dio.post("${API_URL}/collections_payments", data: {
        'collection_id': payment.collectionId,
        'customer_id': widget.customer.id,
        'amount': payment.amount,
        'date': payment.date,
        'notes': payment.notes,
      });

      if (response.statusCode == 201) {
        CollectionPayment newPayment =
            CollectionPayment.fromJson(response.data);
        Navigator.pop(context, newPayment);
      } else {
        showErrorMessage();
      }
    } catch (e) {
      showErrorMessage();
    }
  }

  void showErrorMessage() {
    toastification.show(
      context: context,
      title: const Text('Error al registrar el pago'),
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Pago"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            DateInputPicker(
              title: 'Fecha',
              content: _dateController.text,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() {
                    _dateController.text = date.toString().substring(0, 10);
                  });
                }
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _amountController,
              autofocus: true,
              decoration: InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Por favor, ingrese el monto';
                return null;
              },
            ),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(labelText: 'Notas (opcional)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Registrar Pago'),
            ),
          ],
        ),
      ),
    );
  }
}
