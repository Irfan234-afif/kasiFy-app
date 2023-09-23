part of 'index_bloc.dart';

@immutable
abstract class IndexState {
  final int index;

  const IndexState(this.index);
}

class IndexInitial extends IndexState {
  const IndexInitial(super.index);
}

class IndexChanged extends IndexState {
  const IndexChanged(super.index);
}
