import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/BillCategory.dart';
import 'package:jova_app/screens/bills/details_bill_category.dart';
import 'package:jova_app/screens/bills/new_bill_category_screen.dart';
import 'package:jova_app/widgets/InfoCard.dart';

class BillScreen extends StatefulWidget {
  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text("Gastos"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewBillCategoryScreen()),
              ).then((value) {
                if (value != null) setState(() {});
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<BillCategory>>(
        future: Api.fetchBillCategories(),
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

  Widget _paymentCard(BillCategory category, bool isLast) {
    var gestureDetector = GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsBillCategory(categoryId: category.id!),
          ),
        ).then((value) {
          if (value != null) setState(() {});
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
                      category.name!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
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

  //No results found
  Widget _noResults() {
    return const Center(
      child: Text("No se encontraron resultados"),
    );
  }
}
