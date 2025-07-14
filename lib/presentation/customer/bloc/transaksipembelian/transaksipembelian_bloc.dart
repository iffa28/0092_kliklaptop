import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:kliklaptop/data/model/response/transaksi_pembelian_response_model.dart';
import 'package:kliklaptop/data/repository/transaksi_pembelian_repository.dart';
import 'package:meta/meta.dart';

part 'transaksipembelian_event.dart';
part 'transaksipembelian_state.dart';

class TransaksiPembelianBloc
    extends Bloc<TransaksiPembelianEvent, TransaksiPembelianState> {
  final TransaksiPembelianRepository transaksiRepo;

  TransaksiPembelianBloc({required this.transaksiRepo})
    : super(TransaksiPembelianInitial()) {
    on<TransaksiPembelianRequested>(_onTransaksiRequested);
    on<GetAllTransaksiPembelian>(_onGetAllTransaksi);
    on<DeleteTransaksiPembelian>(_onDeleteTransaksi);
    on<UpdateTransaksiPembelian>(_onUpdateTransaksi);
    on<GetTransaksiPembelianById>(_onGetTransaksiById);
  }

  Future<void> _onTransaksiRequested(
    TransaksiPembelianRequested event,
    Emitter<TransaksiPembelianState> emit,
  ) async {
    emit(TransaksiPembelianLoading());

    final result = await transaksiRepo.addTransaksiPembelian(
      data: event.dataTransaksi,
      buktiPembayaran: event.buktiPembayaran,
    );

    result.fold(
      (l) => emit(TransaksiPembelianFailure(error: l)),
      (r) => emit(TransaksiPembelianSuccess(response: r)),
    );
  }

  Future<void> _onGetAllTransaksi(
    GetAllTransaksiPembelian event,
    Emitter<TransaksiPembelianState> emit,
  ) async {
    emit(TransaksiPembelianLoading());

    final result = await transaksiRepo.getAllTransactions();

    result.fold(
      (l) => emit(TransaksiPembelianFailure(error: l)),
      (r) => emit(TransaksiPembelianListSuccess(transaksiList: r)),
    );
  }

  Future<void> _onDeleteTransaksi(
    DeleteTransaksiPembelian event,
    Emitter<TransaksiPembelianState> emit,
  ) async {
    emit(TransaksiPembelianLoading());

    final result = await transaksiRepo.deleteTransaksi(event.id);

    result.fold((l) => emit(TransaksiPembelianFailure(error: l)), (r) async {
      emit(TransaksiPembelianDeleteSuccess(message: r));
      // Reload list setelah delete
      final reload = await transaksiRepo.getAllTransactions();
      reload.fold(
        (l) => emit(TransaksiPembelianFailure(error: l)),
        (r) => emit(TransaksiPembelianListSuccess(transaksiList: r)),
      );
    });
  }

  Future<void> _onUpdateTransaksi(
    UpdateTransaksiPembelian event,
    Emitter<TransaksiPembelianState> emit,
  ) async {
    emit(TransaksiPembelianLoading());

    final result = await transaksiRepo.updateTransaksiPembelian(
      data: event.dataTransaksiUpdate,
      buktiPembayaran: event.buktiPembayaran,
    );

    result.fold(
      (l) => emit(TransaksiPembelianFailure(error: l)),
      (r) async {
        emit(TransaksiPembelianSuccess(response: r));
        // Reload list setelah update
        final reload = await transaksiRepo.getAllTransactions();
        reload.fold(
          (l) => emit(TransaksiPembelianFailure(error: l)),
          (r) => emit(TransaksiPembelianListSuccess(transaksiList: r)),
        );
      },
    );
  }

  Future<void> _onGetTransaksiById(
    GetTransaksiPembelianById event,
    Emitter<TransaksiPembelianState> emit,
  ) async {
    emit(TransaksiPembelianLoading());

    final result = await transaksiRepo.getTransactionById(event.id);

    result.fold(
      (l) => emit(TransaksiPembelianFailure(error: l)),
      (r) => emit(TransaksiPembelianDetailSuccess(transaksi: r)),
    );
  }
}
