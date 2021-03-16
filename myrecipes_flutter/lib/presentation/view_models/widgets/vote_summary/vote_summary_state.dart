part of 'vote_summary_cubit.dart';

abstract class VoteSummaryState extends Equatable {
  const VoteSummaryState();
}

class VoteSummaryInitial extends VoteSummaryState {
  @override
  List<Object> get props => [];
}

class VoteSummaryLoaded extends VoteSummaryState {
  final List<Vote> upvotes;
  final List<Vote> downVotes;

  VoteSummaryLoaded(this.upvotes, this.downVotes);

  @override
  List<Object> get props => [upvotes, downVotes];
}
