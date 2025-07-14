import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:kliklaptop/data/model/response/servicebyadmin_response_model.dart';
import 'package:kliklaptop/data/repository/servicebyadmin_repository.dart';
import 'package:meta/meta.dart';

part 'servicebyadmin_event.dart';
part 'servicebyadmin_state.dart';

class ServicebyadminBloc extends Bloc<ServiceByAdminEvent, ServiceByAdminState> {
  final ServiceByAdminRepository serviceadminRepo;
  ServicebyadminBloc({required this.serviceadminRepo}) : super(ServiceByAdminInitial()) {
    on<AddServiceByAdminRequested>(_onAddService);
    on<GetServiceByAdminByServiceRequestId>(_onGetByServiceRequestId);
    on<UpdatePembayaranServiceByAdmin>(_onUpdatePembayaran);
  }

  Future<void> _onAddService(
    AddServiceByAdminRequested event,
    Emitter<ServiceByAdminState> emit,
  ) async {
    emit(ServiceByAdminLoading());
    final result = await serviceadminRepo.addServiceByAdmin(
      servicebyadmin: event.serviceData,
      buktiPembayaran: event.buktiPembayaran,
    );

    result.fold(
      (l) => emit(ServiceByAdminFailure(error: l)),
      (r) => emit(ServiceByAdminSuccess(response: r)),
    );
  }

  //  Future<void> _onGetServiceById(
  //   GetServiceByAdminById event,
  //   Emitter<ServiceByAdminState> emit,
  // ) async {
  //   emit(ServiceByAdminLoading());
  //   final result = await serviceadminRepo.getServiceByAdminById(event.id);

  //   result.fold(
  //     (l) => emit(ServiceByAdminFailure(error: l)),
  //     (r) => emit(ServiceByAdminDetailSuccess(service: r)),
  //   );
  // }

  Future<void> _onGetByServiceRequestId(
  GetServiceByAdminByServiceRequestId event,
  Emitter<ServiceByAdminState> emit,
) async {
  emit(ServiceByAdminLoading());

  final result = await serviceadminRepo.getServiceByAdminByServiceRequestId(event.serviceRequestId);

  result.fold(
    (l) => emit(ServiceByAdminFailure(error: l)),
    (r) => emit(ServiceByAdminDetailSuccess(service: r)),
  );
}

  Future<void> _onUpdatePembayaran(
  UpdatePembayaranServiceByAdmin event,
  Emitter<ServiceByAdminState> emit,
) async {
  emit(ServiceByAdminLoading());
  final result = await serviceadminRepo.updatePembayaranServiceByAdmin(
    id: event.serviceId,
    buktiPembayaran: event.buktiPembayaran,
  );

  result.fold(
    (l) => emit(ServiceByAdminFailure(error: l)),
    (r) => emit(UpdatePembayaranSuccess(response: r)),
  );
}

}
