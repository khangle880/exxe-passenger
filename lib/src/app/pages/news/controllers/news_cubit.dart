import 'package:equatable/equatable.dart';

import '../../../../core/base_bloc.dart';
import '../../../../utils/export/repo_export.dart';

part 'news_state.dart';

class NewsCubit extends BaseCubit<NewsState> {
  final INewsControllerRepo _newsControllerRepo =
      GetIt.I<INewsControllerRepo>();

  NewsCubit() : super(const NewsState());

  Future<void> getNewsDetail(String postId) async {
    emitWaiting(true);
    final data = await _newsControllerRepo.getNewsDetail(postId);
    emitWaiting(false);
    data.fold((failure) {
      log(failure.toString());
      emitError(failure);
    }, (data) {
      emit(state.copyWith(newsDetail: data));
    });
  }
}
