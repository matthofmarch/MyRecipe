import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomePageCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository;
  HomePageCubit(this._authRepository) : super(HomePageInitial());


}
