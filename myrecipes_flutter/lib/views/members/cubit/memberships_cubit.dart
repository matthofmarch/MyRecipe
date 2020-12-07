import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:group_repository/src/group_repository.dart';

part 'memberships_state.dart';

class MembershipsCubit extends Cubit<MembershipsState> {
  GroupRepository _groupRepository;

  MembershipsCubit(this._groupRepository) : super(MembershipsInitial());

  getOwnGroup()async{
    emit(MembershipsInitial());
    try{
      emit(MembershipsProgress());
      var group = await _groupRepository.getGroup();
      emit(MembershipsSuccess(group));
    }catch(e){
      emit(MembershipsFailure());
    }
  }
}
