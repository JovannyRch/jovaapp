import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/PaymentsCategory.dart';
import 'package:jova_app/screens/payments/details_payments_category_screen.dart';
import 'package:jova_app/screens/payments/new_payments_category_page.dart';
import 'package:jova_app/utils/formatCurrency.dart';
import 'package:jova_app/widgets/InfoCard.dart';

class PaymentsPage extends StatefulWidget {
  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text("Pagos"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewPaymentsCategoryPage()),
              ).then((value) {
                if (value != null) setState(() {});
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<PaymentsCategory>>(
        future: Api.fetchPaymentsCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return _noResults();
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _paymentCard(
                    snapshot.data![index], index == snapshot.data!.length - 1);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _paymentCard(PaymentsCategory payment, bool isLast) {
    bool hasBudget = payment.budget > 0;
    var gestureDetector = GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailsPaymentsCategoryScreen(categoryId: payment.id),
          ),
        ).then((value) {
          setState(() {});
        });
      },
      child: InfoCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      payment.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (hasBudget) ..._budgetElements(payment),
                    if (!hasBudget) ...[
                      const SizedBox(height: 10),
                      Text(
                        "${formatCurrency(payment.total)} ",
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ]
                  ]),
            ),
            const SizedBox(
              width: 50,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 15.0,
              ),
            ),
          ],
        ),
      ),
    );

    if (!isLast) {
      return Column(
        children: [
          gestureDetector,
          const SizedBox(height: 10.0),
        ],
      );
    }
    return gestureDetector;
  }

  List<Widget> _budgetElements(PaymentsCategory payment) {
    return [
      const SizedBox(height: 20),
      Text(
        "${formatCurrency(payment.total)} de ${formatCurrency(payment.budget)}",
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: payment.percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          const SizedBox(width: 10),
          Text("${payment.percentage.toStringAsFixed(0)}%"),
        ],
      )
    ];
  }

  //No results found
  Widget _noResults() {
    return const Center(
      child: Text("No se encontraron resultados"),
    );
  }
}
