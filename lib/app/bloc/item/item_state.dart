part of 'item_bloc.dart';

@immutable
abstract class ItemState {
  final List<ItemModel>? itemModel;

  const ItemState({this.itemModel});
}

class ItemInitial extends ItemState {
  const ItemInitial({super.itemModel});
}

class ItemLoadingState extends ItemState {}

class ItemLoadedState extends ItemState {
  const ItemLoadedState({super.itemModel});
}

class ItemEmptyState extends ItemState {
  const ItemEmptyState({super.itemModel});
}

class ItemErrorState extends ItemState {
  final String msg;

  const ItemErrorState(this.msg);
}
