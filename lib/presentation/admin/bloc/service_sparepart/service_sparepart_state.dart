part of 'service_sparepart_bloc.dart';

sealed class ServiceSparepartState {}

final class ServiceSparepartInitial extends ServiceSparepartState {}

final class ServiceSparepartLoading extends ServiceSparepartState {}

final class ServiceSparepartSuccess extends ServiceSparepartState {
  final String message;
  ServiceSparepartSuccess(this.message);
}

final class ServiceSparepartMultipleSuccess extends ServiceSparepartState {
  final int addedCount;
  final List<String> failedMessages;

  ServiceSparepartMultipleSuccess({
    required this.addedCount,
    required this.failedMessages,
  });
}

final class ServiceSparepartLoaded extends ServiceSparepartState {
  final List<Data> spareparts;
  ServiceSparepartLoaded({required this.spareparts});
}

final class ServiceSparepartFailure extends ServiceSparepartState {
  final String error;
  ServiceSparepartFailure(this.error);
}
