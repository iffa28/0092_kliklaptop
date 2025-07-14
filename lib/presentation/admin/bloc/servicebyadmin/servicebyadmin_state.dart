part of 'servicebyadmin_bloc.dart';

sealed class ServiceByAdminState {}

final class ServiceByAdminInitial extends ServiceByAdminState {}

final class ServiceByAdminLoading extends ServiceByAdminState {}

final class ServiceByAdminSuccess extends ServiceByAdminState {
  final ServiceByAdminResponseModel response;

  ServiceByAdminSuccess({required this.response});
}

final class AllServiceByAdminLoaded extends ServiceByAdminState {
  final List<DataServiceByAdmin> listServicebyadmin;

  AllServiceByAdminLoaded(this.listServicebyadmin);
}

final class ServiceByAdminFailure extends ServiceByAdminState {
  final String error;

  ServiceByAdminFailure({required this.error});
}

// ====== Ambil satu ======
final class ServiceByAdminDetailSuccess extends ServiceByAdminState {
  final DataServiceByAdmin service;

  ServiceByAdminDetailSuccess({required this.service});
}

class UpdatePembayaranSuccess extends ServiceByAdminState {
  final ServiceByAdminResponseModel response;

  UpdatePembayaranSuccess({required this.response});
}
