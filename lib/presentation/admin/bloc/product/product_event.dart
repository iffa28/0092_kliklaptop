part of 'product_bloc.dart';

sealed class ProductEvent {}

class ProductRequested extends ProductEvent {
  final Data dataProduk;
  final File? fotoProduk;

  ProductRequested({
    required this.dataProduk,
    this.fotoProduk,
  });
}

class ProductAllRequested extends ProductEvent {}

class GetProductById extends ProductEvent {
  final int id;

  GetProductById({required this.id});
}

class UpdateProduct extends ProductEvent {
 final Data updateDataProduk;
  final File? fotoProduk;

  UpdateProduct({required this.updateDataProduk, this.fotoProduk});
}

class DeleteProduct extends ProductEvent {
  final int id;

  DeleteProduct({required this.id});
}
