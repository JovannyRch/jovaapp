import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/PaymentsCategory.dart';
import 'package:jova_app/screens/details_payments_category_screen.dart';
import 'package:jova_app/screens/new_payments_category_page.dart';
import 'package:jova_app/utiilts/formatCurrency.dart';

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
                setState(() {});
              });
            },
          ),
        ],
      ),

      /*   floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPaymentsCategoryPage()),
          );
        },
        child: Icon(Icons.add),
      ), */
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
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                PaymentsCategory payment = snapshot.data![index];
                return _paymentCard(payment);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _paymentCard(PaymentsCategory payment) {
    bool hasBudget = payment.budget > 0;
    return GestureDetector(
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
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
              ]),
        ),
      ),
    );
  }

  List<Widget> _budgetElements(PaymentsCategory payment) {
    return [
      const SizedBox(height: 20),
      Text(
        formatCurrency(payment.budget),
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(height: 10),
      LinearProgressIndicator(
        value: payment.percentage / 100,
        backgroundColor: Colors.grey[300],
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
      )
    ];
  }

  //No results found
  Widget _noResults() {
    return Center(
      child: Text("No se encontraron resultados"),
    );
  }
}
