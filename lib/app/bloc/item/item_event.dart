part of 'item_bloc.dart';

@immutable
abstract class ItemEvent {}

class ItemGetEvent extends ItemEvent {
  final String email;
  ItemGetEvent(this.email);
}

class ItemAddEvent extends ItemEvent {
  final String email;
  final ItemModel itemModel;

  ItemAddEvent(this.email, {required this.itemModel});
}

class ItemEditEvent extends ItemEvent {
  final String email;
  final ItemModel itemModel;

  ItemEditEvent(this.email, {required this.itemModel});
}

class ItemUpdateStockEvent extends ItemEvent {
  final String email;
  final ItemModel itemModel;

  ItemUpdateStockEvent(this.email, {required this.itemModel});
}

class ItemDecreaseStockEvent extends ItemEvent {
  final String email;
  final ItemModel itemModel;

  ItemDecreaseStockEvent(this.email, {required this.itemModel});
}

class ItemRestockEvent extends ItemEvent {
  final String email;
  final String itemName;

  ItemRestockEvent(this.email, {required this.itemName});
}

class ItemEditLocalEvent extends ItemEvent {
  final ItemModel itemModel;

  ItemEditLocalEvent({required this.itemModel});
}

final class ItemDeleteEvent extends ItemEvent {
  final String email;
  final ItemModel itemModel;

  ItemDeleteEvent(this.email, {required this.itemModel});
}

final class ItemEmptyEvent extends ItemEvent {}
