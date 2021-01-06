part of 'household_guard_cubit.dart';

abstract class HouseholdGuardState{

}

class HouseholdGuardInitial extends HouseholdGuardState {

}
class HouseholdGuardCreateOrJoin extends HouseholdGuardState {
  String errorMessage;
  HouseholdGuardCreateOrJoin({this.errorMessage});

}
class HouseholdGuardInGroup extends HouseholdGuardState {

}
