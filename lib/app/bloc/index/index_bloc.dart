import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'index_event.dart';
part 'index_state.dart';

class IndexBloc extends Bloc<IndexEvent, IndexState> {
  IndexBloc() : super(const IndexInitial(0)) {
    on<IndexChangeEvent>((event, emit) {
      emit(IndexChanged(event.index));
    });
  }
}
