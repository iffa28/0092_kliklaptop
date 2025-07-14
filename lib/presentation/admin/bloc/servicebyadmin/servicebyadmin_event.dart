part of 'servicebyadmin_bloc.dart';

sealed class ServiceByAdminEvent {}

// Tambah layanan oleh admin
class AddServiceByAdminRequested extends ServiceByAdminEvent {
  final DataServiceByAdmin serviceData;
  final File? buktiPembayaran;

  AddServiceByAdminRequested({
    required this.serviceData,
    this.buktiPembayaran,
  });
}

// Ambil semua data layanan oleh admin
class GetAllServiceByAdminRequested extends ServiceByAdminEvent {}

// Ambil layanan berdasarkan ID
class GetServiceByAdminById extends ServiceByAdminEvent {
  final int id;

  GetServiceByAdminById({required this.id});
}

// Perbarui layanan oleh admin
class UpdateServiceByAdminRequested extends ServiceByAdminEvent {
  final DataServiceByAdmin serviceData;
  final File? buktiPembayaran;

  UpdateServiceByAdminRequested({
    required this.serviceData,
    this.buktiPembayaran,
  });
}

// Hapus layanan oleh admin
class DeleteServiceByAdminRequested extends ServiceByAdminEvent {
  final int id;

  DeleteServiceByAdminRequested({required this.id});
}

class UpdatePembayaranServiceByAdmin extends ServiceByAdminEvent {
  final int serviceId;
  final File? buktiPembayaran;

  UpdatePembayaranServiceByAdmin({
    required this.serviceId,
    this.buktiPembayaran,
  });
}

class GetServiceByAdminByServiceRequestId extends ServiceByAdminEvent {
  final int serviceRequestId;

  GetServiceByAdminByServiceRequestId({required this.serviceRequestId});
}