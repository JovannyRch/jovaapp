import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/models/Customer.dart';
import 'package:jova_app/screens/new_custumer_page.dart';
import 'package:jova_app/widgets/Avatar.dart';

class CustumersScreen extends StatefulWidget {
  const CustumersScreen({super.key});

  @override
  State<CustumersScreen> createState() => _CustumersScreenState();
}

class _CustumersScreenState extends State<CustumersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewClientPage()),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Customer>>(
        future: Api.fetchCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return _noResults();
          }

          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              Customer customer = snapshot.data![index];
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Avatar(fullName: customer.name ?? ""),
                    title: Text(customer.name!),
                    subtitle: Text(customer.phoneNumber!),
                    onTap: () {
                      Navigator.pop(context, customer);
                    },
                  ),
                  if (index != snapshot.data!.length - 1) const Divider(),
                ],
              );
              ;
            },
          );
        },
      ),
    );
  }

  Widget _noResults() {
    return const Center(
      child: Text("No hay clientes registrados"),
    );
  }
}
