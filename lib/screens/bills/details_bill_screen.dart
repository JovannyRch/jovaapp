import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/Bill.dart';
import 'package:jova_app/models/Reponses/BillCategoryDetails.dart';
import 'package:jova_app/utils/formatCurrency.dart';
import 'package:jova_app/utils/formatDate.dart';
import 'package:jova_app/widgets/InfoCard.dart';
import 'package:jova_app/widgets/InfoText.dart';

class DetailsBillScreen extends StatelessWidget {
  final Bill item;
  final BillCategoryDetails categoryDetails;
  final Dio _dio = Dio();

  DetailsBillScreen({
    Key? key,
    required this.item,
    required this.categoryDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del gasto"),
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
                    content: categoryDetails.name!,
                  ),
                  const SizedBox(height: 15),
                  Info(
                    title: "Monto",
                    content: formatCurrency(
                      double.parse(
                        item.amount.toString(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Info(
                    title: "Fecha",
                    content: formatDate(item.date!),
                  ),
                  if (item.notes != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Info(
                          title: "Notas",
                          content: item.notes!,
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
                        categoryDetails.total.toString(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                onDelete(context);
              },
              child:
                  const Text("Eliminar", style: TextStyle(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }

  void onDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar Gasto"),
          content: const Text("¿Estás seguro de eliminar este gasto?"),
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
    _dio.delete("${API_URL}/bills/${item.id}").then((value) {
      Navigator.pop(context);
      Navigator.pop(context, true);
    }).catchError((e) {
      print("Error al eliminar el gasto: $e");
    });
  }
}
