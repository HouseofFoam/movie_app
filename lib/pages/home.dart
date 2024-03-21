import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/data/remote/service/movie_api_service.dart';
import 'package:movie_app/pages/detail.dart';
import 'package:movie_app/pages/search.dart';
import 'package:movie_app/route_arguments/detail_arguments.dart';
import 'package:movie_app/widget/image_fade_bottom.dart';
import 'package:movie_app/widget/poster.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Home extends StatelessWidget {
  static const route = '/';
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          systemNavigationBarColor: Color.fromARGB(255, 44, 44, 44),
          systemNavigationBarIconBrightness: Brightness.light),
    );
    final movieApi =
        MovieApiService(Dio(BaseOptions(contentType: 'application/json')));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            'lib/images/cinema.png',
                            fit: BoxFit.cover,
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Text(
                        'Cinepop',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textScaler: const TextScaler.linear(1),
                      )),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SearchPage.route);
                          },
                          child: const Icon(Icons.search))
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Text(
                ("New and Trending").toString(),
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
                child: FutureBuilder(
              future: movieApi.getTrending('day', 'all'),
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return Skeletonizer(
                      enabled: !snapshot.hasData,
                      child: CarouselSlider.builder(
                        itemCount: 5,
                        itemBuilder: (context, index, pageView) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Skeleton.replace(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, DetailPage.route,
                                          arguments: DetailArguments(
                                              showId: snapshot
                                                  .data?.results[index].id,
                                              showType: snapshot.data
                                                  ?.results[index].mediaType));
                                    },
                                    child: MaskImage(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        maskWidget:
                                            "https://image.tmdb.org/t/p/original/${snapshot.data?.results[index].backdropPath}"),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, bottom: 8),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 180,
                                        child: Text(
                                          (snapshot.data?.results[index]
                                                      .title ??
                                                  snapshot.data?.results[index]
                                                      .name)
                                              .toString(),
                                          style: GoogleFonts.quicksand(
                                            fontSize: 20,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                                            (snapshot.data?.results[index]
                                                    .voteAverage)
                                                .toString(),
                                            style: GoogleFonts.quicksand(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ]),
                          );
                        },
                        options: CarouselOptions(
                            height: 200,
                            initialPage: 2,
                            autoPlay: true,
                            enlargeCenterPage: true),
                      ));
                }
              }),
            )),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Text(
                ("Movies").toString(),
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                ),
              ),
            ),
            Poster(showFuture: movieApi.getTrending('week', 'movie')),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Text(
                ("TV Show").toString(),
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                ),
              ),
            ),
            Poster(showFuture: movieApi.getTrending('week', 'tv')),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
