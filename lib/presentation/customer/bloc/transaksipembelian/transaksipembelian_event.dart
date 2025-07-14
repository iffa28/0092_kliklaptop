part of 'transaksipembelian_bloc.dart';

sealed class TransaksiPembelianEvent {}

class TransaksiPembelianRequested extends TransaksiPembelianEvent {
  final Data dataTransaksi;
  final File? buktiPembayaran;

  TransaksiPembelianRequested({required this.dataTransaksi, this.buktiPembayaran});
}

class GetAllTransaksiPembelian extends TransaksiPembelianEvent {}

class GetTransaksiPembelianById extends TransaksiPembelianEvent {
  final int id;

  GetTransaksiPembelianById({required this.id});
}

class UpdateTransaksiPembelian extends TransaksiPembelianEvent {
  final Data dataTransaksiUpdate;
  final File? buktiPembayaran;

  UpdateTransaksiPembelian({required this.dataTransaksiUpdate, this.buktiPembayaran});
}

class DeleteTransaksiPembelian extends TransaksiPembelianEvent {
  final int id;

  DeleteTransaksiPembelian({required this.id});
}

class GetUserHistoryTransaction extends TransaksiPembelianEvent {}

class GetUserTransaction extends TransaksiPembelianEvent {}
