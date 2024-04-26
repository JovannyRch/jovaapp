import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/models/CategoryPayments.dart';
import 'package:jova_app/widgets/DateInputPicket.dart';

class NewPaymentPage extends StatefulWidget {
  final int categoryId;
  final Payment? payment;

  NewPaymentPage({required this.categoryId, this.payment});

  @override
  _NewPaymentPageState createState() => _NewPaymentPageState();
}

class _NewPaymentPageState extends State<NewPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();
  bool isEditing = false;

  @override
  initState() {
    super.initState();
    _init();
  }

  void _init() {
    _dateController.text = DateTime.now().toString().substring(0, 10);
    if (widget.payment != null) {
      isEditing = true;
      _amountController.text = widget.payment!.amount!;
      _dateController.text = widget.payment!.date!;
      _notesController.text = widget.payment!.notes ?? '';
    }
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
      final response = isEditing
          ? await dio.put(
              '$API_URL/payments/${widget.payment!.id}',
              data: payment.toJson(),
            )
          : await dio.post(
              '$API_URL/payments',
              data: payment.toJson(),
            );

      if (response.statusCode == 201 || response.statusCode == 200) {
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
              autofocus: !isEditing,
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
              child: Text(isEditing ? 'Editar' : 'Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
