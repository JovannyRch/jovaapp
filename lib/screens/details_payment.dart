import 'package:flutter/material.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/CategoryPayments.dart';
import 'package:jova_app/utiilts/formatCurrency.dart';
import 'package:jova_app/utiilts/sendWhatsAppMessage.dart';
import 'package:jova_app/widgets/InfoCard.dart';
import 'package:jova_app/widgets/InfoText.dart';

class DetailsPayment extends StatelessWidget {
  final Payment payment;

  const DetailsPayment({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Pago"),
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
                    content: payment.date.toString(),
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                String message = "Pago #${payment.id}:\n\n";
                message +=
                    "Monto: ${formatCurrency(double.parse(payment.amount.toString()))}\n";
                message += "Fecha: ${payment.date}\n";
                if (payment.notes != null) {
                  message += "Notas: ${payment.notes}\n";
                }
                sendWhatsAppMessage(message, "7226227577");
              },
              child: const Text("Enviar por WhatsApp"),
            ),
          ],
        ),
      ),
    );
  }
}
