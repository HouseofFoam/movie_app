// To parse this JSON data, do
//
//     final showData = showDataFromJson(jsonString);

import 'dart:convert';

ShowData showDataFromJson(String str) => ShowData.fromJson(json.decode(str));

String showDataToJson(ShowData data) => json.encode(data.toJson());

class ShowData {
  final int? page;
  final List<Result> results;
  final int? totalPages;
  final int? totalResults;

  ShowData({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory ShowData.fromJson(Map<String, dynamic> json) => ShowData(
        page: json["page"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class Result {
  final String? backdropPath;
  final int id;
  final String? title;
  final String? posterPath;
  final String? mediaType;
  final double? voteAverage;
  final String? name;

  Result({
    required this.backdropPath,
    required this.id,
    this.title,
    required this.posterPath,
    required this.mediaType,
    required this.voteAverage,
    this.name,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        backdropPath: json["backdrop_path"],
        id: json["id"],
        title: json["title"],
        posterPath: json["poster_path"],
        mediaType: json["media_type"],
        voteAverage: json["vote_average"]?.toDouble(),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "id": id,
        "title": title,
        "poster_path": posterPath,
        "media_type": mediaType,
        "vote_average": voteAverage,
        "name": name,
      };
}
