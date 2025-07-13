import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:kliklaptop/data/model/request/customer/service_request_model.dart';
import 'package:kliklaptop/data/model/response/servicerequest_response_model.dart';
import 'package:kliklaptop/data/repository/service_request_repository.dart';
import 'package:meta/meta.dart';

part 'service_request_event.dart';
part 'service_request_state.dart';

class ServiceRequestBloc
    extends Bloc<ServiceRequestEvent, ServiceRequestState> {
  final ServiceRequestRepository serviceRepo;
  ServiceRequestBloc({required this.serviceRepo})
    : super(ServiceRequestInitial()) {
    on<ServiceRequestRequested>(_onServiceRequestRequested);
    on<GetAllUserServiceRequests>(_onGetAllService);
    on<DeleteServiceRequests>(_onDeleteService);
    on<GetServiceRequestsById>(_onGetServiceById);
    on<GetUserHistoryService>(_onGetHistoryService);
    on<GetUserService>(_onGetActiveServiceRequests);
  }

  Future<void> _onServiceRequestRequested(
    ServiceRequestRequested event,
    Emitter<ServiceRequestState> emit,
  ) async {
    emit(ServiceRequestLoading());

    final result = await serviceRepo.addServiceRequest(
      dataServiceReq: event.dataService,
      photoFile: event.photo,
    );

    result.fold(
      (l) => emit(ServiceRequestFailure(error: l)),
      (r) => emit(ServiceRequestSuccess(response: r)),
    );
  }

  Future<void> _onGetAllService(
    GetAllUserServiceRequests event,
    Emitter<ServiceRequestState> emit,
  ) async {
    emit(ServiceRequestLoading());

    final result = await serviceRepo.getAllServiceRequests();

    result.fold(
      (l) => emit(ServiceRequestFailure(error: l)),
      (r) => emit(ServiceRequestListSuccess(serviceList: r)),
    );
  }

  Future<void> _onDeleteService(
    DeleteServiceRequests event,
    Emitter<ServiceRequestState> emit,
  ) async {
    emit(ServiceRequestLoading());

    final result = await serviceRepo.deleteService(event.id);

    result.fold((l) => emit(ServiceRequestFailure(error: l)), (r) async {
      emit(ServiceRequestDeleteSuccess(message: r));
      // Reload list setelah delete
      final reload = await serviceRepo.getAllServiceRequests();
      reload.fold(
        (l) => emit(ServiceRequestFailure(error: l)),
        (r) => emit(ServiceRequestListSuccess(serviceList: r)),
      );
    });
  }

  Future<void> _onGetServiceById(
    GetServiceRequestsById event,
    Emitter<ServiceRequestState> emit,
  ) async {
    emit(ServiceRequestLoading());

    final result = await serviceRepo.getServiceRequestsById(event.id);

    result.fold(
      (l) => emit(ServiceRequestFailure(error: l)),
      (r) => emit(ServiceRequestDetailSuccess(service: r)),
    );
  }

  Future<void> _onGetHistoryService(
    GetUserHistoryService event,
    Emitter<ServiceRequestState> emit,
  ) async {
    emit(ServiceRequestLoading());

    final result = await serviceRepo.getHistoryService();

    result.fold(
      (l) => emit(ServiceRequestFailure(error: l)),
      (r) => emit(ServiceRequestListSuccess(serviceList: r)),
    );
  }

  Future<void> _onGetActiveServiceRequests(
    GetUserService event,
    Emitter<ServiceRequestState> emit,
  ) async {
    emit(ServiceRequestLoading());

    final result = await serviceRepo.getActiveServiceRequestsByUser();

    result.fold(
      (l) => emit(ServiceRequestFailure(error: l)),
      (r) => emit(ServiceRequestListSuccess(serviceList: r)),
    );
  }
}
