import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:review_book/src/common/model/naver_book_info.dart';

part 'naver_book_info_result.g.dart';

@JsonSerializable()
class NaverBookInfoResults extends Equatable {
  final int? total;
  final int? start;
  final int? display;
  final List<NaverBookInfo?>? items;

  const NaverBookInfoResults.init()
      : this(start: 1, display: 10, items: const []);
  const NaverBookInfoResults({
    this.total,
    this.start,
    this.display,
    this.items,
  });

  factory NaverBookInfoResults.fromJson(Map<String, dynamic> json) =>
      _$NaverBookInfoResultsFromJson(json);

  @override
  List<Object?> get props => [
        total,
        start,
        display,
        items,
      ];

  NaverBookInfoResults copyWith({
    int? total,
    int? start,
    int? display,
    List<NaverBookInfo?>? items,
  }) {
    return NaverBookInfoResults(
        total: total ?? this.total,
        start: start ?? this.start,
        display: display ?? this.display,
        items: [...this.items ?? [], ...items ?? []]);
  }
}
