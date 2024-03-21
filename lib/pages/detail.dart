import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/data/model/detail_show.dart';
import 'package:movie_app/data/remote/service/movie_api_service.dart';
import 'package:movie_app/route_arguments/detail_arguments.dart';
import 'package:movie_app/widget/image_fade_bottom.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailPage extends StatelessWidget {
  static const route = '/detail';
  final DetailArguments detailArguments;
  const DetailPage({super.key, required this.detailArguments});

  @override
  Widget build(BuildContext context) {
    final movieApi =
        MovieApiService(Dio(BaseOptions(contentType: 'application/json')));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      body: FutureBuilder(
          future: movieApi.getDetailShow(
              detailArguments.showType, detailArguments.showId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Column(
                children: [
                  Text(
                    snapshot.error.toString(),
                  ),
                  Text("${detailArguments.showType}, ${detailArguments.showId}")
                ],
              ));
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Skeletonizer(
                        enabled: !snapshot.hasData,
                        child: Column(
                          children: [
                            detailBanner(context, snapshot),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    ("PLAY").toString(),
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  textScaler: const TextScaler.linear(1),
                                  textAlign: TextAlign.justify,
                                  ((snapshot.data?.overview).toString())
                                      .toString(),
                                  style: GoogleFonts.quicksand(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Stack detailBanner(BuildContext context, AsyncSnapshot<DetailShow> snapshot) {
    return Stack(
      children: [
        Skeleton.replace(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 2 / 3,
            child: MaskImage(
              maskWidget: snapshot.data?.posterPath == null
                  ? "https://images.ratemyagent.com/ratemyagent/image/upload/q_auto:eco,f_auto,w_900,h_600,c_limit/cdn-nz/922844e7-e427-ec11-ab22-06f9814e2bd6"
                  : "https://image.tmdb.org/t/p/original/${snapshot.data?.posterPath}",
              width: double.infinity,
            )),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(162, 3, 168, 244),
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(162, 3, 168, 244),
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.movie),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: bannerDescription(context, snapshot),
          ),
        )
      ],
    );
  }

  Row bannerDescription(
      BuildContext context, AsyncSnapshot<DetailShow> snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${detailArguments.showType}".toUpperCase(),
              style: GoogleFonts.quicksand(shadows: [
                const Shadow(
                    color: Color.fromARGB(64, 0, 0, 0), offset: Offset(0, 2))
              ]),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Text(
                overflow: TextOverflow.ellipsis,
                (snapshot.data?.title ?? snapshot.data?.name).toString(),
                style: GoogleFonts.quicksand(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(
                          color: Color.fromARGB(64, 0, 0, 0),
                          offset: Offset(0, 2))
                    ]),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(87, 0, 0, 0),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                (snapshot.data?.genres?[0].name).toString(),
                style: GoogleFonts.quicksand(),
              ),
            )
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.lightBlue,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              (snapshot.data?.voteAverage).toString(),
              style: GoogleFonts.quicksand(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
