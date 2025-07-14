part of 'product_bloc.dart';

sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductSuccess extends ProductState {
  final ProductResponseModel response;

  ProductSuccess({required this.response});
}

final class ProductFailure extends ProductState {
  final String error;

  ProductFailure({required this.error});
}

class ProductListSuccess extends ProductState {
  final List<Data> products;
  ProductListSuccess({required this.products});
}


// ====== Ambil satu ======
final class ProductDetailSuccess extends ProductState {
  final Data transaksi;

  ProductDetailSuccess({required this.transaksi});
}

// ====== Update ======
final class ProductUpdateSuccess extends ProductState {
  final String message;

  ProductUpdateSuccess({required this.message});
}

// ====== Hapus ======
final class ProductDeleteSuccess extends ProductState {
  final String message;

  ProductDeleteSuccess({required this.message});
}
