import 'package:dio/dio.dart';
import 'package:jova_app/models/CategoryPayments.dart';
import 'package:jova_app/models/Customer.dart';
import 'package:jova_app/models/PaymentsCategory.dart';
import 'package:jova_app/models/Reponses/PaymentCategoryDetails.dart';

//const String API_URL = 'https://dewvisi.nyc.dom.my.id/api';
const String API_URL = 'https://8ca2-138-84-56-92.ngrok-free.app/api';

class Api {
  static final dio = Dio();
  static Future<dynamic> get(String url) async {
    try {
      final response = await dio.get('$API_URL/$url');
      return response.data;
    } catch (e) {
      return null;
    }
  }

  static Future<List<PaymentsCategory>> fetchPaymentsCategories() async {
    try {
      Response response = await dio.get('$API_URL/payments_categories');
      List<PaymentsCategory> payments = (response.data as List).map((data) {
        print(data);
        return PaymentsCategory.fromJson(data);
      }).toList();
      return payments;
    } catch (error) {
      print("Error al obtener datos: $error");
      throw error;
    }
  }

  static Future<List<Customer>> fetchCustomers() async {
    try {
      Response response = await dio.get('$API_URL/customers');
      List<Customer> customers = (response.data as List).map((data) {
        return Customer.fromJson(data);
      }).toList();
      return customers;
    } catch (error) {
      print("Error al obtener datos: $error");
      throw error;
    }
  }

  static Future<PaymentCategoryDetailsResponse> fetchPaymentCategoryDetails(
      int categoryId) async {
    try {
      Response response =
          await dio.get('$API_URL/payments_categories/$categoryId/details');
      PaymentCategoryDetailsResponse details =
          PaymentCategoryDetailsResponse.fromJson(response.data);
      return details;
    } catch (error) {
      print("Error al obtener datos: $error");
      throw error;
    }
  }
}
