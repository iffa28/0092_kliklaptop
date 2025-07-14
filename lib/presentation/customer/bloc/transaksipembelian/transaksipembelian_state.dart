part of 'transaksipembelian_bloc.dart';

sealed class TransaksiPembelianState {}

final class TransaksiPembelianInitial extends TransaksiPembelianState {}

final class TransaksiPembelianLoading extends TransaksiPembelianState {}

final class TransaksiPembelianSuccess extends TransaksiPembelianState {
  final TransaksiPembelianResponseModel response;

  TransaksiPembelianSuccess({required this.response});
}

final class TransaksiPembelianFailure extends TransaksiPembelianState {
  final String error;

  TransaksiPembelianFailure({required this.error});
}

class TransaksiPembelianListSuccess extends TransaksiPembelianState {
  final List<Data> transaksiList; 
  TransaksiPembelianListSuccess({required this.transaksiList});
}

// ====== Ambil satu ======
final class TransaksiPembelianDetailSuccess extends TransaksiPembelianState {
  final Data transaksi;

  TransaksiPembelianDetailSuccess({required this.transaksi});
}

// ====== Update ======
final class TransaksiPembelianUpdateSuccess extends TransaksiPembelianState {
  final String message;

  TransaksiPembelianUpdateSuccess({required this.message});
}

// ====== Hapus ======
final class TransaksiPembelianDeleteSuccess extends TransaksiPembelianState {
  final String message;

  TransaksiPembelianDeleteSuccess({required this.message});
}
