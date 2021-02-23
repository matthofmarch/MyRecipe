part of 'memberships_cubit.dart';

abstract class MembershipsState extends Equatable {
  const MembershipsState();

  @override
  List<Object> get props => [];
}

class MembershipsInitial extends MembershipsState {}

class MembershipsProgress extends MembershipsState {}

class MembershipsFailure extends MembershipsState {}

class MembershipsSuccess extends MembershipsState {
  var group;

  MembershipsSuccess(this.group);

  @override
  List<Object> get props => [group];
}
