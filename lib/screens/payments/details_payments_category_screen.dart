import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/CategoryPayments.dart';
import 'package:jova_app/models/Reponses/PaymentCategoryDetails.dart';
import 'package:jova_app/screens/general/pdf_viewer.dart';
import 'package:jova_app/screens/payments/details_payment.dart';
import 'package:jova_app/screens/payments/new_payment_page.dart';
import 'package:jova_app/screens/payments/new_payments_category_page.dart';
import 'package:jova_app/utils/formatCurrency.dart';
import 'package:jova_app/utils/formatDate.dart';
import 'package:jova_app/widgets/InfoCard.dart';
import 'package:jova_app/widgets/InfoText.dart';

class DetailsPaymentsCategoryScreen extends StatefulWidget {
  final int categoryId;

  DetailsPaymentsCategoryScreen({required this.categoryId});

  @override
  State<DetailsPaymentsCategoryScreen> createState() =>
      _DetailsPaymentsCategoryScreenState();
}

class _DetailsPaymentsCategoryScreenState
    extends State<DetailsPaymentsCategoryScreen> {
  Size? size;
  String title = "";
  PaymentCategoryDetailsResponse? response;
  bool _isLoading = true;
  bool hasBudget = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future refresh() async {
    setState(() {
      _isLoading = true;
    });
    final value = await Api.fetchPaymentCategoryDetails(widget.categoryId);

    setState(() {
      response = value;
      title = response!.name!;
      hasBudget = response!.budget != null &&
          response!.budget!.isNotEmpty &&
          double.parse(response!.budget!) > 0;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles pagos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              Payment? payment = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPaymentPage(
                    categoryId: widget.categoryId,
                  ),
                ),
              );

              if (payment != null) {
                await refresh();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPayment(
                      payment: payment,
                      category: response!,
                    ),
                  ),
                );
              }
            },
          ),
          //PDF
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final url =
                  "${API_URL}/payments_categories/${widget.categoryId}/report";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFViewerScreen(
                    url: url,
                    title: "Registro de pagos",
                  ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: refresh,
              child: SingleChildScrollView(
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
                                builder: (context) => NewPaymentsCategoryPage(
                                  category: response!,
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
            //title
            Info(
              title: "Categoría",
              content: response!.name!,
            ),
            const SizedBox(height: 15),

            if (response!.customer != null) ...[
              Info(title: "Responsable", content: response!.customer!.name!),
              const SizedBox(height: 15),
            ],
            if (hasBudget) ..._budgetElements(),
            if (!hasBudget)
              Info(
                title: "Total pagado",
                content: formatCurrency(double.parse(response!.total!)),
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
                Api.deletePaymentCategory(widget.categoryId).then((value) {
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

  List<Widget> _budgetElements() {
    return [
      Info(
        title: "Presupuesto",
        content: formatCurrency(double.parse(response!.budget!)),
      ),
      const Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Info(
              title: "Pagado",
              content: formatCurrency(double.parse(response!.total!))),
          const SizedBox(height: 15),
          Info(
            title: "Restante",
            content: formatCurrency(
              double.parse(response!.budget!) - double.parse(response!.total!),
            ),
          ),
        ],
      ),
      const SizedBox(height: 15),
      progressIndicator(),
    ];
  }

  Widget progressIndicator() {
    return LinearProgressIndicator(
      value: double.parse(response!.percentage!.toString()) / 100,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
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
      child: response!.payments!.length == 0
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
                      "${response!.payments!.length} ${response!.payments!.length == 1 ? 'pago' : 'pagos'}",
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
                    itemCount: response!.payments!.length,
                    itemBuilder: (context, index) {
                      Payment payment = response!.payments![index];
                      return _paymentCard(
                        payment,
                        index == response!.payments!.length - 1,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _paymentCard(Payment payment, bool isLast) {
    var listTile = ListTile(
      title: Text(
        formatDate(payment.date!),
        style: const TextStyle(
          fontSize: 14.0,
          color: kSubtitleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: payment.notes != null
          ? Text(
              payment.notes!,
              style: const TextStyle(
                fontSize: 14.0,
                color: kSubtitleColor,
              ),
            )
          : null,
      trailing: Text(
        formatCurrency(double.parse(payment.amount.toString())),
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPayment(
              payment: payment,
              category: response!,
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
