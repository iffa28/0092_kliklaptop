part of 'service_request_bloc.dart';

sealed class ServiceRequestState {}

final class ServiceRequestInitial extends ServiceRequestState {}

final class ServiceRequestLoading extends ServiceRequestState {}

final class ServiceRequestSuccess extends ServiceRequestState {
  final ServiceRequestResponseModel response;

  ServiceRequestSuccess({required this.response});
}

final class ServiceRequestFailure extends ServiceRequestState {
  final String error;

  ServiceRequestFailure({required this.error});
}

class ServiceRequestListSuccess extends ServiceRequestState {
  final List<Data> serviceList; 
  ServiceRequestListSuccess({required this.serviceList});
}

// ====== Ambil satu ======
final class ServiceRequestDetailSuccess extends ServiceRequestState {
  final Data service;

  ServiceRequestDetailSuccess({required this.service});
}

// ====== Update ======
final class ServiceRequestUpdateSuccess extends ServiceRequestState {
  final String message;

  ServiceRequestUpdateSuccess({required this.message});
}

// ====== Hapus ======
final class ServiceRequestDeleteSuccess extends ServiceRequestState {
  final String message;

  ServiceRequestDeleteSuccess({required this.message});
}
