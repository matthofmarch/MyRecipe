import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:group_repository/src/group_repository.dart';

part 'household_guard_state.dart';

class HouseholdGuardCubit extends Cubit<HouseholdGuardState> {
  GroupRepository _groupRepository;

  //TODO: Eventually listen on user behaviour subject
  HouseholdGuardCubit(this._groupRepository) : super(HouseholdGuardInitial());

  Future<void> checkHouseholdState()async{
    try{
      var group = await _groupRepository.getGroupForUser();
      emit(HouseholdGuardInGroup());
    }catch(e){
      emit(HouseholdGuardCreateOrJoin());
    }
  }

  Future<void> createHousehold(String name) async {
    try{await _groupRepository.create(name);}
    catch(e){
      log(e.toString());
    }
    checkHouseholdState();
  }

  Future<void> joinWithCode(String inviteCode) async {
    try{
      await _groupRepository.joinWithInviteCode(inviteCode);
    }catch(e){
      log(e.toString());
    }
    checkHouseholdState();

  }
}
