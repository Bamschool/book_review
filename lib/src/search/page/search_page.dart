import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:review_book/src/common/components/Input_widget.dart';
import 'package:review_book/src/common/components/app_font.dart';
import 'package:review_book/src/common/components/enum/common_state_status.dart';
import 'package:review_book/src/common/model/naver_book_info.dart';
import 'package:review_book/src/search/cubit/search_book_cubit.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: context.pop,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                'assets/svg/icons/icon_arrow_back.svg',
              ),
            ),
          ),
          title: const AppFonts(
            text: '책 검색',
            size: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Column(
            children: [
              InputWidget(
                onSearch: context.read<SearchBookCubit>().search,
              ),
              const Expanded(child: _SearchResultView())
            ],
          ),
        ));
  }
}

class _SearchResultView extends StatefulWidget {
  const _SearchResultView({Key? key}) : super(key: key);

  @override
  State<_SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<_SearchResultView> {
  late SearchBookCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      if (controller.offset > controller.position.maxScrollExtent - 100 &&
          cubit.state.status == CommonStateStatus.loaded) {
        print("call Next Page");
        cubit.nextPage();
      }
    });
  }

  ScrollController controller = ScrollController();

  Widget _messageView(String message) {
    return Center(
      child: AppFonts(
        text: message,
        size: 20,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  Widget result() {
    return ListView.separated(
        controller: controller,
        itemBuilder: (context, index) {
          NaverBookInfo bookInfo = cubit.state.result!.items![index]!;
          return Row(
            children: [
              SizedBox(
                width: 75,
                height: 115,
                child: Image.network(bookInfo.image ?? ''),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppFonts(
                      size: 16,
                      text: bookInfo.title ?? '',
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppFonts(
                      size: 13,
                      text: bookInfo.author ?? '',
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                      color: const Color(0xff878787),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppFonts(
                      size: 12,
                      text: bookInfo.description ?? '',
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                      color: const Color(0xff838383),
                    )
                  ],
                ),
              )
            ],
          );
        },
        separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                color: Color(0xff262626),
              ),
            ),
        itemCount: cubit.state.result?.items?.length ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    cubit = context.watch<SearchBookCubit>();
    if (cubit.state.status == CommonStateStatus.init) {
      return _messageView("리뷰할 책을 찾아보세요");
    }
    if (cubit.state.status == CommonStateStatus.loaded &&
        (cubit.state.result == null || cubit.state.result!.items!.isEmpty)) {
      return _messageView("검색된 결과가 없습니다");
    }
    // Add a default return statement or a throw statement here
    return result(); // Replace Container() with your desired Widget
  }
}
