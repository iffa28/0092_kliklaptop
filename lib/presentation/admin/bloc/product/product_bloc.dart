import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:kliklaptop/data/model/request/admin/product_request_model.dart';
import 'package:kliklaptop/data/model/response/product_response_model.dart';
import 'package:kliklaptop/data/repository/product_repository.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepo;

  ProductBloc({required this.productRepo}) : super(ProductInitial()) {
    on<ProductRequested>(_onProductRequested);
    on<ProductAllRequested>(_onProductAllRequested);
    on<DeleteProduct>(_onDeleteProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<GetProductById>(_onGetProductById);
  }

  Future<void> _onProductRequested(
    ProductRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await productRepo.addProduct(
      data: event.dataProduk,
      photoFile: event.fotoProduk,
    );

    result.fold(
      (l) => emit(ProductFailure(error: l)),
      (r) => emit(ProductSuccess(response: r)),
    );
  }

  Future<void> _onProductAllRequested(
    ProductAllRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await productRepo.getAllProducts();

    result.fold(
      (l) => emit(ProductFailure(error: l)),
      (r) => emit(ProductListSuccess(products: r)),
    );
  }

  Future<void> _onGetProductById(
    GetProductById event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await productRepo.getProductById(event.id);

    result.fold(
      (l) => emit(ProductFailure(error: l)),
      (r) {
        if (r.data != null) {
          emit(ProductDetailSuccess(transaksi: r.data!));
        } else {
          emit(ProductFailure(error: 'Produk tidak ditemukan'));
        }
      },
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await productRepo.updateProduct(
      productData: event.updateDataProduk,
      photoFile: event.fotoProduk,
    );

    result.fold(
      (l) => emit(ProductFailure(error: l)),
      (r) => emit(ProductUpdateSuccess(message: r.message ?? "Berhasil memperbarui produk")),
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await productRepo.deleteProduct(event.id);

    result.fold(
      (l) => emit(ProductFailure(error: l)),
      (r) => emit(ProductDeleteSuccess(message: r.message ?? "Produk berhasil dihapus")),
    );
  }
}
