part of 'household_guard_cubit.dart';

abstract class HouseholdGuardState {
  const HouseholdGuardState();
}

class HouseholdGuardInitial extends HouseholdGuardState {
  const HouseholdGuardInitial();
}

class HouseholdGuardCreateOrJoin extends HouseholdGuardState {
  final String errorMessage;

  const HouseholdGuardCreateOrJoin({this.errorMessage});
}

class HouseholdGuardInGroup extends HouseholdGuardState {}
