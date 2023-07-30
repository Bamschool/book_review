part of 'search_book_cubit.dart';

class SearchBookState extends Equatable {
  final CommonStateStatus status;
  final NaverBookInfoResults? result;
  final NaverBookSearchOption? searchOption;
  const SearchBookState({
    this.status = CommonStateStatus.init,
    this.result = const NaverBookInfoResults.init(),
    this.searchOption,
  });

  SearchBookState copyWith({
    CommonStateStatus? status,
    NaverBookInfoResults? result,
    NaverBookSearchOption? searchOption,
  }) {
    return SearchBookState(
      status: status ?? this.status,
      result: result ?? this.result,
      searchOption: searchOption ?? this.searchOption,
    );
  }

  @override
  String toString() =>
      'SearchBookState(status: $status, result: $result, searchOption: $searchOption)';

  @override
  List<Object?> get props => [status, result, searchOption];
}
