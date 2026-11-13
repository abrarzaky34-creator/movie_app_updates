import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/movie_details_cubit.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailsCubit()
        ..loadMovie(movieId),
      child: MovieDetailsView(movieId: movieId),
    );
  }
}

class MovieDetailsView extends StatefulWidget {
  final int movieId;

  const MovieDetailsView({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailsView> createState() =>
      _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<MovieDetailsView> {
  bool isBookmarked = false;

  static const Color backgroundColor = Color(0xFF1F1F1F);
  static const Color cardColor = Color(0xFF292929);
  static const Color yellowColor = Color(0xFFFFC400);
  static const Color redColor = Color(0xFFED2024);

  Widget movieImage(
      String? imageUrl, {
        BoxFit fit = BoxFit.cover,
      }) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        color: cardColor,
        child: const Center(
          child: Icon(
            Icons.movie,
            color: Colors.white54,
            size: 45,
          ),
        ),
      );
    }

    return Image.network(
      imageUrl,
      fit: fit,
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          color: cardColor,
          child: const Center(
            child: CircularProgressIndicator(
              color: yellowColor,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: cardColor,
          child: const Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.white54,
              size: 40,
            ),
          ),
        );
      },
    );
  }

  Widget statCard(IconData icon, String value) {
    return Expanded(
      child: Container(
        height: 54,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: yellowColor,
              size: 30,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget playButton() {
    return Container(
      width: 108,
      height: 108,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: yellowColor,
        border: Border.all(
          color: Colors.white,
          width: 7,
        ),
      ),
      child: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: 65,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              color: const Color(0xFF292929),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 28,
                  ),
                  const Spacer(),
                  const Text(
                    'Movies',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 28),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: yellowColor,
                      ),
                    );
                  }

                  if (state.error != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: redColor,
                              size: 50,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              state.error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<MovieDetailsCubit>()
                                    .loadMovie(widget.movieId);
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final movie = state.movie;

                  if (movie == null) {
                    return const SizedBox();
                  }

                  final String title =
                      movie['title']?.toString() ?? '';

                  final String year =
                      movie['year']?.toString() ?? '';

                  final String rating =
                      movie['rating']?.toString() ?? '0.0';

                  final String runtime =
                      movie['runtime']?.toString() ?? '0';

                  final String likes =
                      movie['like_count']?.toString() ?? '0';

                  final String? poster =
                      movie['large_cover_image']?.toString() ??
                          movie['medium_cover_image']?.toString();

                  final List<dynamic> screenshots = [
                    movie['medium_screenshot_image1'],
                    movie['medium_screenshot_image2'],
                    movie['medium_screenshot_image3'],
                  ].where(
                        (image) =>
                    image != null &&
                        image.toString().isNotEmpty,
                  ).toList();

                  return SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 520,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            18, 30, 18, 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 0.67,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    movieImage(poster),

                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 0.30, 0.65, 1.0],
                                          colors: [
                                            Color(0x55000000),
                                            Color(0x08000000),
                                            Color(0x99000000),
                                            Color(0xFF111111),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      top: 18,
                                      left: 8,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_ios_new,
                                          color: Colors.white,
                                          size: 27,
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      top: 18,
                                      right: 8,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isBookmarked = !isBookmarked;
                                          });
                                        },
                                        icon: Icon(
                                          isBookmarked
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                    ),

                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Movie preview is not available.',
                                              ),
                                            ),
                                          );
                                        },
                                        child: playButton(),
                                      ),
                                    ),

                                    Positioned(
                                      bottom: 25,
                                      left: 12,
                                      right: 12,
                                      child: Column(
                                        children: [
                                          Text(
                                            title,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              height: 1.3,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          Text(
                                            year,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 22),

                              SizedBox(
                                height: 65,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Movie preview is not available.',
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: redColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                  ),
                                  child: const Text(
                                    'Watch',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              Row(
                                children: [
                                  statCard(Icons.favorite, likes),
                                  statCard(Icons.access_time_filled, runtime),
                                  statCard(Icons.star, rating),
                                ],
                              ),

                              const SizedBox(height: 30),

                              const Text(
                                'Screen Shots',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20),

                              if (screenshots.isNotEmpty)
                                SizedBox(
                                  height: 145,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: screenshots.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 280,
                                        margin: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        child: movieImage(
                                          screenshots[index].toString(),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              else
                                const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Text(
                                      'No screenshots available',
                                      style: TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
