import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';

part 'root_bottom_navigation_state.dart';

class ContentRootCubit extends Cubit<ContentRootState> {
  AuthRepository _authRepository;

  ContentRootCubit(this._authRepository) : super(ContentRootInitial());

  void logout() {
    _authRepository.logout();
  }
}
