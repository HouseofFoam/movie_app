import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/data/model/show_data.dart';
import 'package:movie_app/data/remote/service/movie_api_service.dart';
import 'package:movie_app/pages/detail.dart';
import 'package:movie_app/route_arguments/detail_arguments.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchPage extends StatefulWidget {
  static const route = "/search";
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String search = "a";
  // int? numberOfPages = 500;
  // int? currentPages = 1;

  // void changeNumberOfPages(int? newNumberOfPages) {
  //   setState(() {
  //     numberOfPages = newNumberOfPages;
  //   });
  // }

  // void changeCurrentPage(int? newCurrentPages) {
  //   setState(() {
  //     currentPages = newCurrentPages;
  //   });
  // }

  void changeSearch(String newSearch) {
    setState(() {
      search = newSearch;
    });
  }

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (mounted) {
  //       changeCurrentPage(1);
  //       changeNumberOfPages(1);
  //     }
  //   });
  //   super.initState();
  // }

  final movieApi =
      MovieApiService(Dio(BaseOptions(contentType: 'application/json')));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: Card(
        //   margin: EdgeInsets.zero,
        //   elevation: 4,
        //   child: NumberPaginator(
        //     numberPages: numberOfPages ?? 0,
        //     onPageChange: (page) => changeCurrentPage(page + 1),
        //     config: const NumberPaginatorUIConfig(
        //         buttonSelectedBackgroundColor: Colors.white,
        //         buttonSelectedForegroundColor: Color.fromARGB(255, 44, 44, 44),
        //         buttonUnselectedBackgroundColor:
        //             Color.fromARGB(255, 44, 44, 44),
        //         buttonUnselectedForegroundColor: Colors.white),
        //   ),
        // ),
        backgroundColor: const Color.fromARGB(255, 44, 44, 44),
        body: Column(
          children: [
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: changeSearch,
                decoration: InputDecoration(
                    icon: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                    iconColor: Colors.white,
                    fillColor: const Color.fromARGB(255, 27, 27, 27),
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12)),
                    hintText: "Search your show",
                    hintStyle: GoogleFonts.lato()),
                style: GoogleFonts.lato(),
              ),
            )),
            const Divider(
              height: 3,
              color: Color.fromARGB(255, 27, 27, 27),
            ),
            Expanded(
              child: FutureBuilder(
                  future: movieApi.searchShow(
                      page: 1, search: search.isEmpty ? "a" : search),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      if (snapshot.data?.totalResults == 0) {
                        return const Center(
                            child: Text(
                                "The Show that you're trying to search doesn't exist"));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GridView.builder(
                              itemCount: snapshot.data?.results.length,
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                      crossAxisSpacing: 12,
                                      maxCrossAxisExtent:
                                          MediaQuery.of(context).size.width / 2,
                                      mainAxisExtent: 400),
                              itemBuilder: (context, index) {
                                String? posterPath =
                                    snapshot.data?.results[index].posterPath;
                                return Column(children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Skeletonizer(
                                    enabled: !snapshot.hasData,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, DetailPage.route,
                                            arguments: DetailArguments(
                                                showId: snapshot
                                                    .data?.results[index].id,
                                                showType: snapshot
                                                    .data
                                                    ?.results[index]
                                                    .mediaType));
                                      },
                                      child: searchPosterColumn(
                                          posterPath, snapshot, index),
                                    ),
                                  ),
                                ]);
                              }),
                        );
                      }
                    }
                  }),
            )
          ],
        ));
  }

  Column searchPosterColumn(
      String? posterPath, AsyncSnapshot<ShowData?> snapshot, int index) {
    return Column(children: [
      SizedBox(
        height: 300,
        width: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Skeleton.replace(
            height: 300,
            width: 200,
            child: Image.network(
              posterPath == null
                  ? "https://images.ratemyagent.com/ratemyagent/image/upload/q_auto:eco,f_auto,w_900,h_600,c_limit/cdn-nz/922844e7-e427-ec11-ab22-06f9814e2bd6"
                  : "https://image.tmdb.org/t/p/w500/$posterPath",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      SizedBox(
        width: 180,
        child: Text(
          (snapshot.data?.results[index].title ??
                  snapshot.data?.results[index].name)
              .toString(),
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.lato(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      )
    ]);
  }
}
