import 'package:dio/dio.dart';
import 'package:jova_app/models/BillCategory.dart';
import 'package:jova_app/models/CollectionCategory.dart';
import 'package:jova_app/models/Customer.dart';
import 'package:jova_app/models/PaymentsCategory.dart';
import 'package:jova_app/models/Reponses/BillCategoryDetails.dart';
import 'package:jova_app/models/Reponses/CollectionCategoryDetails.dart';
import 'package:jova_app/models/Reponses/PaymentCategoryDetails.dart';

const String API_URL = 'https://bocnoka.nyc.dom.my.id/api';

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
      print('$API_URL/payments_categories/$categoryId/details');
      print("response.data: ${response.data}");
      PaymentCategoryDetailsResponse details =
          PaymentCategoryDetailsResponse.fromJson(response.data);
      return details;
    } catch (error) {
      print("Error al obtener datos: $error");
      throw error;
    }
  }

  static Future<BillCategoryDetails> fetchBillCategoryDetails(
      int categoryId) async {
    try {
      Response response =
          await dio.get('$API_URL/bill_categories/$categoryId/details');
      BillCategoryDetails details = BillCategoryDetails.fromJson(response.data);
      return details;
    } catch (error) {
      print("Error al obtener datos: $error");
      throw error;
    }
  }

  static Future<CollectionCategoryDetails> fetchCollectionCategoryDetails(
      int categoryId) async {
    try {
      Response response =
          await dio.get('$API_URL/collections_categories/$categoryId/details');
      CollectionCategoryDetails details =
          CollectionCategoryDetails.fromJson(response.data);
      return details;
    } catch (error) {
      print("Error al obtener datos: $error");
      throw error;
    }
  }

  static Future deletePaymentCategory(int categoryId) async {
    try {
      await dio.delete('$API_URL/payments_categories/$categoryId');
    } catch (error) {
      print("Error al eliminar la categoría de pago: $error");
      throw error;
    }
  }

  static Future deleteBillCategory(int categoryId) async {
    try {
      await dio.delete('$API_URL/bill_categories/$categoryId');
    } catch (error) {
      print("Error al eliminar la categoría de pago: $error");
      throw error;
    }
  }

  static Future deleteCollectionCategory(int categoryId) async {
    try {
      await dio.delete('$API_URL/collections_categories/$categoryId');
    } catch (error) {
      print("Error al eliminar la categoría de pago: $error");
      throw error;
    }
  }

  static Future<List<BillCategory>> fetchBillCategories() async {
    try {
      Response response = await dio.get('$API_URL/bill_categories');
      List<BillCategory> billCategories = (response.data as List).map((data) {
        return BillCategory.fromJson(data);
      }).toList();
      return billCategories;
    } catch (error) {
      print("Error al obtener datos: $error");
      throw error;
    }
  }

  static Future<List<CollectionCategory>> fetchCollectionCategories() async {
    try {
      Response response = await dio.get('$API_URL/collections_categories');
      List<CollectionCategory> categories = (response.data as List).map((data) {
        return CollectionCategory.fromJson(data);
      }).toList();
      return categories;
    } catch (error) {
      print("Error al obtener datos: $error");
      throw error;
    }
  }

  static Future<List<T>> getList<T>(
      String url, T Function(Map<String, dynamic>) fromJson) async {
    try {
      Response response = await dio.get('$API_URL/$url');
      print(response);
      List<T> items = (response.data as List).map((data) {
        return fromJson(data);
      }).toList();
      return items;
    } catch (error) {
      print("Error al obtener datos: $error");
      throw error;
    }
  }
}
