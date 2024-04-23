import 'package:flutter/material.dart';
import 'package:jova_app/api/api.dart';
import 'package:jova_app/const/conts.dart';
import 'package:jova_app/models/CategoryPayments.dart';
import 'package:jova_app/models/Reponses/PaymentCategoryDetails.dart';
import 'package:jova_app/screens/details_payment.dart';
import 'package:jova_app/screens/new_payment_page.dart';
import 'package:jova_app/utiilts/formatCurrency.dart';
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

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    setState(() {
      _isLoading = true;
    });
    Api.fetchPaymentCategoryDetails(widget.categoryId).then((value) {
      setState(() {
        response = value;
        title = response!.name!;
      });
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
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
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPaymentPage(
                    categoryId: widget.categoryId,
                  ),
                ),
              );
              setState(() {});
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
      padding: const EdgeInsets.all(15.0),
      child: InfoCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Info(
              title: "Presupuesto total",
              content: formatCurrency(double.tryParse(
                    response!.budget!,
                  ) ??
                  0),
            ),
            const SizedBox(height: 15),
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
                    double.parse(response!.budget!) -
                        double.parse(response!.total!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            progressIndicator(),
          ],
        ),
      ),
    );
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
        payment.date.toString(),
        style: const TextStyle(
          fontSize: 14.0,
          color: kSubtitleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(payment.notes ?? ""),
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
            ),
          ),
        );
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
