import 'package:bloc/bloc.dart';
import 'package:kliklaptop/data/model/request/auth/login_request.dart';
import 'package:kliklaptop/data/model/response/auth/auth_response.dart';
import 'package:kliklaptop/data/repository/auth_repository.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
    // TODO: implement event handler
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState>emit
    ) async {
    emit(LoginLoading());

    final result = await authRepository.login(event.requestModel);

    result.fold(
      (l) => emit(LoginFailure(error: l)),
      (r) => emit(LoginSuccess(responseModel: r)),
    );
  }
}
