part of 'service_sparepart_bloc.dart';

@immutable
abstract class ServiceSparepartState {}

class ServiceSparepartInitial extends ServiceSparepartState {}

class ServiceSparepartLoading extends ServiceSparepartState {}

class ServiceSparepartFailure extends ServiceSparepartState {
  final String error;

  ServiceSparepartFailure(this.error);
}

class ServiceSparepartSuccess extends ServiceSparepartState {
  final ServiceSparepartResponseModel response;

  ServiceSparepartSuccess(this.response);
}

class ServiceSparepartLoaded extends ServiceSparepartState {
  final List<Data> spareparts;

  ServiceSparepartLoaded({required this.spareparts});
}
