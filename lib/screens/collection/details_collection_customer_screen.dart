import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/Collection/CollectionPayment.dart';
import 'package:jova_app/models/CollectionCategory.dart';
import 'package:jova_app/models/Customer.dart';
import 'package:jova_app/screens/collection/details_collection_payment_screen.dart';
import 'package:jova_app/screens/collection/new_collection_payment_screen.dart';
import 'package:jova_app/utiilts/formatCurrency.dart';
import 'package:jova_app/utiilts/formatDate.dart';
import 'package:jova_app/widgets/InfoCard.dart';
import 'package:jova_app/widgets/InfoText.dart';

class DetailsCollectionCustomerScreen extends StatefulWidget {
  final CollectionCategory category;
  final Customer customer;

  DetailsCollectionCustomerScreen({
    required this.category,
    required this.customer,
  });

  @override
  State<DetailsCollectionCustomerScreen> createState() =>
      _DetailsCollectionCustomerScreenState();
}

class _DetailsCollectionCustomerScreenState
    extends State<DetailsCollectionCustomerScreen> {
  Size? size;
  List<CollectionPayment>? payments;
  bool _isLoading = true;
  Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future refresh() async {
    setState(() {
      _isLoading = true;
    });
    final value = await Api.getList<CollectionPayment>(
        "collections_categories/${widget.category.id}/customer/${widget.customer.id}/payments",
        CollectionPayment.fromJson);

    setState(() {
      payments = value;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagos usuario"),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                CollectionPayment? payment = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewCollectionPaymentScreen(
                      category: widget.category,
                      customer: widget.customer,
                    ),
                  ),
                );

                if (payment != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsCollectionPayment(
                        payment: payment,
                        category: widget.category,
                        customer: widget.customer,
                      ),
                    ),
                  ).then((value) {
                    refresh();
                  });
                }
              }),
        ],
      ),
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _header(),
                  const SizedBox(height: 10),
                  _payments(),
                ],
              ),
            ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
      child: InfoCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Image
                if (widget.category.image != null)
                  Image.network(
                    widget.category.image!,
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ),
                if (widget.category.image == null)
                  const SizedBox(
                    width: 35.0,
                    height: 35.0,
                  ),
                if (widget.category.name != null) ...[
                  const SizedBox(width: 10),
                  Info(
                    title: "Categoría",
                    content: widget.category.name!,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 15),
            Info(
              title: "Cliente",
              content: widget.customer.name!,
            ),
          ],
        ),
      ),
    );
  }

  void onDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar"),
          content:
              const Text("¿Estás seguro de que deseas eliminar esta Pago?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  Widget _payments() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: payments!.isEmpty
          ? _noResults()
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  //Total
                  ListTile(
                    title: Text(
                      "${payments!.length} ${payments!.length == 1 ? 'pago' : 'pagos'}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: kSubtitleColor,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: payments!.length,
                    itemBuilder: (context, index) {
                      CollectionPayment item = payments![index];
                      return _item(
                        item,
                        index == payments!.length - 1,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _item(CollectionPayment item, bool isLast) {
    var listTile = ListTile(
      title: Text(
        formatDate(item.date!),
        style: const TextStyle(
          fontSize: 14.0,
          color: kSubtitleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: item.notes != null
          ? Text(
              item.notes!,
              style: const TextStyle(
                fontSize: 14.0,
                color: kSubtitleColor,
              ),
            )
          : null,
      trailing: Text(
        formatCurrency(
          double.parse(
            item.amount.toString(),
          ),
        ),
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsCollectionPayment(
              payment: item,
              category: widget.category,
              customer: widget.customer,
            ),
          ),
        ).then((value) {
          if (value != null) {
            refresh();
          }
        });
      },
    );
    return !isLast
        ? Column(
            children: [
              listTile,
              const Divider(),
            ],
          )
        : listTile;
  }

  Widget _noResults() {
    return SizedBox(
      height: size!.height * 0.7,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.warning,
            size: 50,
            color: kSubtitleColor,
          ),
          SizedBox(height: 10),
          Text(
            "No hay pagos registrados",
            style: TextStyle(
              color: kSubtitleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
