part of 'index_bloc.dart';

@immutable
abstract class IndexEvent {}

class IndexChangeEvent extends IndexEvent {
  final int index;

  IndexChangeEvent(this.index);
}
