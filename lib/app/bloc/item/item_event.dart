part of 'item_bloc.dart';

@immutable
abstract class ItemEvent {}

class ItemInitialEvent extends ItemEvent {
  final String token;

  ItemInitialEvent(this.token);
}

class ItemAddEvent extends ItemEvent {
  final String token;
  final ItemModel itemModel;

  ItemAddEvent(this.token, {required this.itemModel});
}

class ItemEditEvent extends ItemEvent {
  final String token;
  final ItemModel itemModel;

  ItemEditEvent(this.token, {required this.itemModel});
}

final class ItemDeleteEvent extends ItemEvent {
  final String token;
  final ItemModel itemModel;

  ItemDeleteEvent(this.token, {required this.itemModel});
}

final class ItemEmptyEvent extends ItemEvent {}
