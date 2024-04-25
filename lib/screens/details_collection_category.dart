import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/CollectionCategory.dart';
import 'package:jova_app/models/Customer.dart';
import 'package:jova_app/models/Reponses/CollectionCategoryDetails.dart';
import 'package:jova_app/screens/customers_screen.dart';
import 'package:jova_app/screens/new_collection_category_screen.dart';
import 'package:jova_app/widgets/InfoCard.dart';
import 'package:jova_app/widgets/InfoText.dart';
import 'package:toastification/toastification.dart';

class DetailsCollectionCategory extends StatefulWidget {
  final int categoryId;

  DetailsCollectionCategory({required this.categoryId});

  @override
  State<DetailsCollectionCategory> createState() =>
      _DetailsCollectionCategoryState();
}

class _DetailsCollectionCategoryState extends State<DetailsCollectionCategory> {
  Size? size;
  String title = "";
  CollectionCategoryDetails? details;
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
    final value = await Api.fetchCollectionCategoryDetails(widget.categoryId);

    setState(() {
      details = value;
      title = details!.name!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomersScreen(
                    multiSelect: true,
                  ),
                ),
              ).then((value) {
                if (value != null) {
                  Customer customer = value;

                  //Check if the customer is already in the list
                  if (details!.customers!
                      .map((e) => e.id)
                      .contains(customer.id)) {
                    toastification.show(
                      context: context,
                      title: const Text('El cliente ya está en la lista'),
                      type: ToastificationType.warning,
                      style: ToastificationStyle.flatColored,
                      autoCloseDuration: const Duration(seconds: 5),
                      alignment: Alignment.bottomCenter,
                    );

                    return;
                  }

                  _dio.post(
                    "${API_URL}/collections_categories/${widget.categoryId}/addCustomer",
                    data: {
                      "customer_id": customer.id,
                    },
                  ).then((response) {
                    if (response.statusCode == 201) {
                      refresh();
                    }
                  }).catchError((e) {
                    print("Error al agregar cliente: $e");
                  });
                }
              });
            },
          ),
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
                  if (details!.image != null || details!.description != null)
                    _header(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          onDelete();
                        },
                        child: const Text(
                          "Eliminar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewCollectionCategoryScreen(
                                category: CollectionCategory(
                                  id: details!.id,
                                  name: details!.name,
                                  description: details!.description,
                                  image: details!.image,
                                ),
                              ),
                            ),
                          ).then((value) {
                            if (value != null) {
                              refresh();
                            }
                          });
                        },
                        child: const Text("Editar"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _customers(),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Image
            if (details!.image != null)
              Image.network(
                details!.image!,
                width: 35.0,
                height: 35.0,
                fit: BoxFit.cover,
              ),
            if (details!.image == null)
              const SizedBox(
                width: 35.0,
                height: 35.0,
              ),
            if (details!.description != null) ...[
              const SizedBox(width: 10),
              Info(
                title: "Descripción",
                content: details!.description!,
              ),
            ]
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
          content: const Text(
              "¿Estás seguro de que deseas eliminar esta categoría?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Api.deleteCollectionCategory(widget.categoryId).then((value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void onRemoveCustomer(Customer customer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar"),
          content: const Text(
              "¿Estás seguro de que deseas eliminar este cliente de la categoría?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _dio
                    .delete(
                  "${API_URL}/collections_categories/${widget.categoryId}/removeCustomer/${customer.id}",
                )
                    .then((response) {
                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                    refresh();
                  }
                }).catchError((e) {
                  toastification.show(
                    context: context,
                    title: const Text('Error al eliminar el cliente'),
                    type: ToastificationType.error,
                    style: ToastificationStyle.flatColored,
                    autoCloseDuration: const Duration(seconds: 5),
                    alignment: Alignment.bottomCenter,
                  );
                });
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  Widget _customers() {
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
      child: details!.customers!.isEmpty
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
                      "${details!.customers!.length} ${details!.customers!.length == 1 ? 'cliente' : 'clientes'}",
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
                    itemCount: details!.customers!.length,
                    itemBuilder: (context, index) {
                      Customer item = details!.customers![index];
                      return _item(
                        item,
                        index == details!.customers!.length - 1,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _item(Customer item, bool isLast) {
    var listTile = ListTile(
      title: Text(
        item.name!,
        style: const TextStyle(
          fontSize: 14.0,
          color: kSubtitleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: item.phoneNumber != null
          ? Text(
              item.phoneNumber!,
              style: const TextStyle(
                fontSize: 14.0,
                color: kSubtitleColor,
              ),
            )
          : null,
      onTap: () {
        /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsBillScreen(
              item: bill,
              categoryDetails: details!,
            ),
          ),
        ).then((value) {
          if (value != null) {
            refresh();
          }
        }); */
      },
      onLongPress: () => onRemoveCustomer(item),
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
            "No hay clientes registrados",
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
