part of 'news_cubit.dart';

class NewsState extends Equatable {
  final NewsDetailModel? newsDetail;

  const NewsState({
    this.newsDetail,
  });

  @override
  List<Object?> get props => [
        newsDetail,
      ];

  NewsState copyWith({
    NewsDetailModel? newsDetail,
  }) {
    return NewsState(
      newsDetail: newsDetail ?? this.newsDetail,
    );
  }
}
