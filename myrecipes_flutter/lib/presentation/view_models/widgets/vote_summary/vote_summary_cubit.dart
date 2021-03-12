import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myrecipes_flutter/domain/models/vote.dart';

part 'vote_summary_state.dart';

class VoteSummaryCubit extends Cubit<VoteSummaryState> {
  VoteSummaryCubit() : super(VoteSummaryInitial());
}
