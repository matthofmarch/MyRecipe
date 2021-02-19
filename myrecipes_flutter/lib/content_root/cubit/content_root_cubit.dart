import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'content_root_state.dart';

class ContentRootCubit extends Cubit<ContentRootState> {
  AuthRepository _authRepository;

  ContentRootCubit(this._authRepository) : super(ContentRootInitial());

  void logout() {
    _authRepository.logout();
  }
}
