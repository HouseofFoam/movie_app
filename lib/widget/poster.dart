import 'package:flutter/material.dart';
import 'package:movie_app/data/model/show_data.dart';
import 'package:movie_app/pages/detail.dart';
import 'package:movie_app/route_arguments/detail_arguments.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Poster extends StatelessWidget {
  final Future<ShowData> showFuture;
  const Poster({super.key, required this.showFuture});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: FutureBuilder(
          future: showFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Skeletonizer(
                enabled: !snapshot.hasData,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.results.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Skeleton.replace(
                            height: 200,
                            width: 134,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, DetailPage.route,
                                    arguments: DetailArguments(
                                        showId:
                                            snapshot.data?.results[index].id,
                                        showType: snapshot
                                            .data?.results[index].mediaType));
                              },
                              child: Image.network(
                                  "https://image.tmdb.org/t/p/w500/${snapshot.data?.results[index].posterPath}",
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
          }),
    );
  }
}
