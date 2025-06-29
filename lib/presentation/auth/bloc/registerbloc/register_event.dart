part of 'register_bloc.dart';

sealed class RegisterEvent {}

class RegisterRequested extends RegisterEvent {
  final RegisterRequest requestModel;

  RegisterRequested({required this.requestModel});
}

