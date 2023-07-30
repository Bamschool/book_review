import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:review_book/src/common/components/enum/common_state_status.dart';
import 'package:review_book/src/common/model/naver_book_info_result.dart';
import 'package:review_book/src/common/model/naver_book_search_option.dart';
import 'package:review_book/src/common/repository/naver_api_repository.dart';

part 'search_book_state.dart';

class SearchBookCubit extends Cubit<SearchBookState> {
  final NaverBookRepository _naverBookRepository;
  SearchBookCubit(this._naverBookRepository) : super(const SearchBookState());

  void nextPage() {
    emit(
      state.copyWith(
        status: CommonStateStatus.loading,
        searchOption: state.searchOption!.copyWith(
          start: state.searchOption!.start! + state.searchOption!.display!,
        ),
      ),
    );
    search(state.searchOption!.query ?? '');
  }

  void search(String searchKey) async {
    emit(
      state.copyWith(
        status: CommonStateStatus.loading,
        searchOption: state.searchOption!.copyWith(query: searchKey),
      ),
    );

    var result = await _naverBookRepository.searchBooks(state.searchOption!);
    if (result.start! > result.total! || result.items!.isEmpty) {
      emit(
        state.copyWith(
          status: CommonStateStatus.completed,
        ),
      );
    }
    emit(state.copyWith(
        status: CommonStateStatus.loaded,
        result: state.result!.copyWith(items: result.items)));
    print(result);
  }
}
