import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/CategoryPayments.dart';
import 'package:jova_app/models/Reponses/PaymentCategoryDetails.dart';
import 'package:jova_app/screens/payments/new_payment_page.dart';
import 'package:jova_app/utils/formatCurrency.dart';
import 'package:jova_app/utils/formatDate.dart';
import 'package:jova_app/utils/sendWhatsAppMessage.dart';
import 'package:jova_app/widgets/InfoCard.dart';
import 'package:jova_app/widgets/InfoText.dart';

class DetailsPayment extends StatefulWidget {
  final Payment payment;
  final PaymentCategoryDetailsResponse category;

  DetailsPayment({
    Key? key,
    required this.payment,
    required this.category,
  }) : super(key: key);

  @override
  State<DetailsPayment> createState() => _DetailsPaymentState();
}

class _DetailsPaymentState extends State<DetailsPayment> {
  final Dio _dio = Dio();
  late Payment payment;
  bool hasChanges = false;

  initState() {
    super.initState();
    payment = widget.payment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Pago"),
        actions: [
          IconButton(
            onPressed: () {
              onDelete(context);
            },
            icon: const Icon(Icons.delete),
          ),
          //Edit
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPaymentPage(
                    categoryId: widget.category.id!,
                    payment: payment,
                  ),
                ),
              ).then((value) {
                if (value != null) {
                  setState(() {
                    hasChanges = true;
                    payment = value;
                  });
                }
              });
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Info(
                    title: "Categoría",
                    content: widget.category.name!,
                  ),
                  const SizedBox(height: 15),
                  Info(
                    title: "Monto",
                    content: formatCurrency(
                      double.parse(
                        payment.amount.toString(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Info(
                    title: "Fecha",
                    content: formatDate(payment.date!),
                  ),
                  if (payment.notes != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Info(
                          title: "Notas",
                          content: payment.notes!,
                        ),
                      ],
                    ),
                  const Divider(
                    height: 20.0,
                  ),
                  Info(
                    title: "Acomulado",
                    content: formatCurrency(
                      double.parse(
                        widget.category.total.toString(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                onSendMessage();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text(
                    "Compartir por WhatsApp",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSendMessage() {
    String message = "Registro de Pago - ${widget.category.name}\n\n";
    message +=
        "Monto: ${formatCurrency(double.parse(payment.amount.toString()))}\n";
    message += "Fecha: ${formatDate(payment.date!)}\n";
    if (payment.notes != null) {
      message += "Notas: ${payment.notes}\n";
    }
    message +=
        "\nTotal acomulado: ${formatCurrency(double.parse(widget.category.total.toString()))}\n";
    sendWhatsAppMessage(message, widget.category.customer!.phoneNumber!);
  }

  void onDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar Pago"),
          content: const Text("¿Estás seguro de eliminar este pago?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                onDeletePayment(context);
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void onDeletePayment(BuildContext context) {
    _dio.delete("${API_URL}/payments/${payment.id}").then((value) {
      Navigator.pop(context);
      Navigator.pop(context, true);
    }).catchError((e) {
      print("Error al eliminar el pago: $e");
    });
  }
}
