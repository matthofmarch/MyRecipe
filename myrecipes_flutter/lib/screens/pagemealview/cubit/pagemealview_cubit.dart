import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pagemealview_state.dart';

class PagemealviewCubit extends Cubit<PagemealviewState> {
  PagemealviewCubit() : super(PagemealviewInitial());
}
