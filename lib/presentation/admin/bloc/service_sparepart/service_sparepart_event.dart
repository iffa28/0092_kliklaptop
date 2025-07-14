part of 'service_sparepart_bloc.dart';

sealed class ServiceSparepartEvent {}

final class AddSingleSparepart extends ServiceSparepartEvent {
  final ServiceSparepartRequestModel request;

  AddSingleSparepart(this.request);
}

final class AddMultipleSpareparts extends ServiceSparepartEvent {
  final List<ServiceSparepartRequestModel> requests;

  AddMultipleSpareparts(this.requests);
}

final class GetSparepartsByServiceId extends ServiceSparepartEvent {
  final int serviceByAdminId;

  GetSparepartsByServiceId(this.serviceByAdminId);
}
