import 'package:movie_app/data/model/detail_show.dart';
import 'package:movie_app/data/model/show_data.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
part 'movie_api_service.g.dart';

@RestApi(baseUrl: 'https://api.themoviedb.org/3/')
abstract class MovieApiService {
  factory MovieApiService(Dio dio) = _MovieApiService;

  @GET('trending/{type}/{timeWindow}')
  @Headers(<String, dynamic>{
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3YTNhOTc2MThiM2I2MzZjMjNjNjIxNGQ4ZDA3YTJmMSIsInN1YiI6IjY1ZWU4ZjIwMDAxYmJkMDE4NjdmMzA4OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Cya-57ej4N6lkjiaSBTjLiN9f3oqyH8qfXUcrtbvhx4',
  })
  Future<ShowData> getTrending(
      @Path('timeWindow') String timeWindow, @Path('type') String type);

  @GET('{showType}/{showId}')
  @Headers(<String, dynamic>{
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3YTNhOTc2MThiM2I2MzZjMjNjNjIxNGQ4ZDA3YTJmMSIsInN1YiI6IjY1ZWU4ZjIwMDAxYmJkMDE4NjdmMzA4OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Cya-57ej4N6lkjiaSBTjLiN9f3oqyH8qfXUcrtbvhx4',
  })
  Future<DetailShow> getDetailShow(
      @Path('showType') String? showType, @Path('showId') int? showId);

  @GET('search/multi')
  @Headers(<String, dynamic>{
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3YTNhOTc2MThiM2I2MzZjMjNjNjIxNGQ4ZDA3YTJmMSIsInN1YiI6IjY1ZWU4ZjIwMDAxYmJkMDE4NjdmMzA4OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Cya-57ej4N6lkjiaSBTjLiN9f3oqyH8qfXUcrtbvhx4',
  })
  Future<ShowData?> searchShow(
      {@Query('query') String search = "a", @Query('page') required int page});
}
