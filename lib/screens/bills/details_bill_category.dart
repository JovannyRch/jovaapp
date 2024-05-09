import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/Bill.dart';
import 'package:jova_app/models/BillCategory.dart';
import 'package:jova_app/models/Reponses/BillCategoryDetails.dart';
import 'package:jova_app/screens/bills/details_bill_screen.dart';
import 'package:jova_app/screens/bills/new_bill_category_screen.dart';
import 'package:jova_app/screens/bills/new_bill_screen.dart';
import 'package:jova_app/screens/general/pdf_viewer.dart';
import 'package:jova_app/utils/formatCurrency.dart';
import 'package:jova_app/utils/formatDate.dart';
import 'package:jova_app/widgets/InfoCard.dart';
import 'package:jova_app/widgets/InfoText.dart';

class DetailsBillCategory extends StatefulWidget {
  final int categoryId;

  DetailsBillCategory({required this.categoryId});

  @override
  State<DetailsBillCategory> createState() => _DetailsBillCategoryState();
}

class _DetailsBillCategoryState extends State<DetailsBillCategory> {
  Size? size;
  String title = "";
  BillCategoryDetails? details;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future refresh() async {
    setState(() {
      _isLoading = true;
    });
    final value = await Api.fetchBillCategoryDetails(widget.categoryId);

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
              Bill? item = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewBillScreen(
                    categoryId: widget.categoryId,
                  ),
                ),
              );

              if (item != null) {
                await refresh();
                /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPayment(
                      payment: payment,
                    ),
                  ),
                ); */
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final url =
                  "${API_URL}/bill_categories/${widget.categoryId}/report";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFViewerScreen(
                    url: url,
                    title: "Registro de gastos",
                  ),
                ),
              );
            },
          )
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
                              builder: (context) => NewBillCategoryScreen(
                                category: BillCategory(
                                  id: details!.id,
                                  name: details!.name,
                                ),
                              ),
                            ),
                          ).then((value) {
                            refresh();
                          });
                        },
                        child: const Text("Editar"),
                      ),
                    ],
                  ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Info(
              title: "Total gastado",
              content: formatCurrency(double.parse(details!.total!)),
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
                Api.deleteBillCategory(widget.categoryId).then((value) {
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
      child: details!.bills!.isEmpty
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
                      "${details!.bills!.length} ${details!.bills!.length == 1 ? 'gasto' : 'gastos'}",
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
                    itemCount: details!.bills!.length,
                    itemBuilder: (context, index) {
                      Bill bill = details!.bills![index];
                      return _item(
                        bill,
                        index == details!.bills!.length - 1,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _item(Bill bill, bool isLast) {
    var listTile = ListTile(
      title: Text(
        formatDate(bill.date!),
        style: const TextStyle(
          fontSize: 14.0,
          color: kSubtitleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: bill.notes != null
          ? Text(
              bill.notes!,
              style: const TextStyle(
                fontSize: 14.0,
                color: kSubtitleColor,
              ),
            )
          : null,
      trailing: Text(
        formatCurrency(double.parse(bill.amount.toString())),
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.push(
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
            "No hay gastos registrados",
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
