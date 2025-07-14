import 'package:bloc/bloc.dart';
import 'package:kliklaptop/data/model/request/admin/service_sparepart_request_model.dart';
import 'package:kliklaptop/data/repository/service_sparepart_repository.dart';
import 'package:meta/meta.dart';

import '../../../../data/model/response/service_sparepart_response_model.dart';

part 'service_sparepart_event.dart';
part 'service_sparepart_state.dart';

class ServiceSparepartBloc extends Bloc<ServiceSparepartEvent, ServiceSparepartState> {
  final ServiceSparepartRepository repository;

  ServiceSparepartBloc({required this.repository}) : super(ServiceSparepartInitial()) {
    on<AddSingleSparepart>(_onAddSingle);
    on<AddMultipleSpareparts>(_onAddMultiple);
    on<GetSparepartsByServiceId>(_onGetSpareparts);
    
  }

  Future<void> _onAddSingle(
    AddSingleSparepart event,
    Emitter<ServiceSparepartState> emit,
  ) async {
    emit(ServiceSparepartLoading());
    final result = await repository.addMultipleSpareparts([event.request]);
    result.fold(
      (error) => emit(ServiceSparepartFailure(error)),
      (msg) => emit(ServiceSparepartSuccess(msg)),
    );
  }

  Future<void> _onAddMultiple(
    AddMultipleSpareparts event,
    Emitter<ServiceSparepartState> emit,
  ) async {
    emit(ServiceSparepartLoading());
    final result = await repository.addMultipleSpareparts(event.requests);
    result.fold(
      (error) => emit(ServiceSparepartFailure(error)),
      (msg) => emit(ServiceSparepartSuccess(msg)),
    );
  }

  Future<void> _onGetSpareparts(
    GetSparepartsByServiceId event,
    Emitter<ServiceSparepartState> emit,
  ) async {
    emit(ServiceSparepartLoading());
    final result = await repository.getSparepartsByServiceId(event.serviceByAdminId);
    result.fold(
      (error) => emit(ServiceSparepartFailure(error)),
      (data) => emit(ServiceSparepartLoaded(spareparts: data)),
    );
  }
}
