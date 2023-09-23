part of 'search_cubit.dart';

@immutable
sealed class SearchState<T> {
  final dynamic data;

  const SearchState({this.data});
}

final class SearchInitial<T> extends SearchState {
  const SearchInitial({super.data});
}

final class SearchComplete<T> extends SearchState {
  final T result;
  const SearchComplete({required this.result, super.data});
}

final class SearchEmpty extends SearchState {
  const SearchEmpty({super.data});
}

final class SearchOff extends SearchState {
  const SearchOff({super.data});
}
