part of 'service_request_bloc.dart';

sealed class ServiceRequestEvent {}

class ServiceRequestRequested extends ServiceRequestEvent {
  final Data dataService;
  final File? photo;

  ServiceRequestRequested({
    required this.dataService,
    this.photo,
  });
}

class GetAllUserServiceRequests extends ServiceRequestEvent {}

class GetServiceRequestsById extends ServiceRequestEvent {
  final int id;

  GetServiceRequestsById({required this.id});
}

class UpdateServiceRequests extends ServiceRequestEvent {
  final Data updateService;
  final File? photo;

  UpdateServiceRequests({
    required this.updateService,
    this.photo,
  });
}

class DeleteServiceRequests extends ServiceRequestEvent {
  final int id;

  DeleteServiceRequests({required this.id});
}

class GetUserHistoryService extends ServiceRequestEvent {}

class GetUserService extends ServiceRequestEvent {}
