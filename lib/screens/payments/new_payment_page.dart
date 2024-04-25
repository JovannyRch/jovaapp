import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/models/CategoryPayments.dart';
import 'package:jova_app/widgets/DateInputPicket.dart';

class NewPaymentPage extends StatefulWidget {
  final int categoryId;

  NewPaymentPage({required this.categoryId});

  @override
  _NewPaymentPageState createState() => _NewPaymentPageState();
}

class _NewPaymentPageState extends State<NewPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  initState() {
    super.initState();
    _dateController.text = DateTime.now().toString().substring(0, 10);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final payment = Payment(
        categoryId: widget.categoryId,
        amount: _amountController.text,
        date: _dateController.text,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      _sendPaymentData(payment);
    }
  }

  Future<void> _sendPaymentData(Payment payment) async {
    try {
      var dio = Dio();
      final response = await dio.post("${API_URL}/payments", data: {
        'category_id': payment.categoryId,
        'amount': payment.amount,
        'date': payment.date,
        'notes': payment.notes,
      });

      if (response.statusCode == 201) {
        Payment newPayment = Payment.fromJson(response.data);
        Navigator.pop(context, newPayment);
      } else {
        print('Error al registrar el pago');
      }
    } catch (e) {
      print('Error al enviar los datos: $e');
    }
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
