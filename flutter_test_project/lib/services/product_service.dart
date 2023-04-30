import 'package:dio/dio.dart';
import 'package:flutter_test_project/model/product_model.dart';
import '../config/dio_config.dart';

class ProductService {
  Future<List<Product>> getProduct() async {
    List<Product> products = <Product>[];
    try {
      var response = await ApiClient().fetch('/products');

      response.data['products'].forEach((data) {
        print("/-----------PRODUCT---------------/");
        print(data['id'].runtimeType);
        print(data['title'].runtimeType);
        print(data['description'].runtimeType);
        print(data['price'].runtimeType);
        print(data['discountPercentage'].runtimeType);
        print(data['rating'].runtimeType);
        print(data['stock'].runtimeType);
        print(data['brand'].runtimeType);
        print(data['category'].runtimeType);
        print(data['thumbnail'].runtimeType);
        print(data['images'].runtimeType);
        products.add(Product.fromJson(data));
      });

      return products;
    } on DioError catch (e) {
      print('Error sending request ${e.message}!');
    }
    return products;
  }
}
