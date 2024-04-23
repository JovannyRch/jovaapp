import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/models/Customer.dart';
import 'package:jova_app/screens/details_customer_screen.dart';
import 'package:jova_app/screens/new_custumer_page.dart';
import 'package:jova_app/widgets/Avatar.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar Cliente"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              Customer? customer = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewClientPage()),
              );

              if (customer != null) {
                Navigator.pop(context, customer);
              }
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
                      onLongPress: () {
                        //Go to DetailsCustomerScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsCustomerScreen(
                              customer: customer,
                            ),
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      }),
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
