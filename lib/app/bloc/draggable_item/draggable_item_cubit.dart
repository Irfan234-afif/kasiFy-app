import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'draggable_item_state.dart';

class DraggableItemCubit extends Cubit<DraggableItemState> {
  DraggableItemCubit() : super(DraggableItemOff());

  void dragOn() {
    emit(DraggableItemOn());
  }

  void dragOff() {
    emit(DraggableItemOff());
  }
}
