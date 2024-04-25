import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/Customer.dart';
import 'package:jova_app/screens/customers/new_custumer_page.dart';
import 'package:jova_app/widgets/InfoCard.dart';
import 'package:jova_app/widgets/InfoText.dart';

class DetailsCustomerScreen extends StatefulWidget {
  final Customer customer;

  DetailsCustomerScreen({required this.customer});

  @override
  State<DetailsCustomerScreen> createState() => _DetailsCustomerScreenState();
}

class _DetailsCustomerScreenState extends State<DetailsCustomerScreen> {
  Dio _dio = Dio();
  Customer? customer;

  initState() {
    super.initState();
    customer = widget.customer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Cliente"),
      ),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Info(title: "Nombre", content: customer!.name!),
                  const SizedBox(height: 15),
                  Info(title: "Teléfono", content: customer!.phoneNumber!),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  onDelete(context);
                },
                child: const Text(
                  "Eliminar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Customer? updatedCustomer = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewClientPage(
                        customer: customer,
                      ),
                    ),
                  );
                  if (updatedCustomer != null) {
                    setState(() {
                      customer = updatedCustomer;
                    });
                  }
                },
                child: const Text("Editar"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void onDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar Cliente"),
          content: const Text("¿Está seguro que desea eliminar este cliente?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await _deleteCustomer().then((value) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  Future _deleteCustomer() async {
    var response =
        await _dio.delete("$API_URL/customers/${widget.customer.id}");

    return response;
  }
}
