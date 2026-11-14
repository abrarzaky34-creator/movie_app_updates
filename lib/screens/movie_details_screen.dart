
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
      create: (_) => MovieDetailsCubit()..loadMovie(movieId),
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
            size: 40,
          ),
        ),
      );
    }

    return Image.network(
      imageUrl,
      width: double.infinity,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return Container(
          color: cardColor,
          child: const Center(
            child: CircularProgressIndicator(
              color: yellowColor,
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) {
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

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget statCard(IconData icon, String value) {
    return Expanded(
      child: Container(
        height: 52,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: yellowColor,
              size: 25,
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget screenshotSection(List<dynamic> screenshots) {
    if (screenshots.isEmpty) {
      return const Text(
        'No screenshots available',
        style: TextStyle(color: Colors.white54),
      );
    }

    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: screenshots.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 280,
              child: movieImage(
                screenshots[index].toString(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget similarMovies(List<Map<String, dynamic>> movies) {
    if (movies.isEmpty) {
      return const Text(
        'No similar movies available',
        style: TextStyle(color: Colors.white54),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: movies.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.67,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];

        final String image =
            movie['medium_cover_image']?.toString() ?? '';

        final double rating =
            double.tryParse(
              movie['rating']?.toString() ?? '0',
            ) ?? 0;

        return GestureDetector(
          onTap: () {
            final id = int.tryParse(
              movie['id']?.toString() ?? '',
            );

            if (id != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsScreen(
                    movieId: id,
                  ),
                ),
              );
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Stack(
              fit: StackFit.expand,
              children: [
                movieImage(image),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.star,
                          color: yellowColor,
                          size: 13,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget castSection(List<dynamic> cast) {
    if (cast.isEmpty) {
      return const Text(
        'Cast information is not available',
        style: TextStyle(color: Colors.white54),
      );
    }

    return Column(
      children: cast.map((item) {
        final Map<String, dynamic> actor =
        Map<String, dynamic>.from(item);

        final String name =
            actor['name']?.toString() ?? 'Unknown';

        final String character =
            actor['character_name']?.toString() ??
                actor['character']?.toString() ??
                'Unknown';

        final String image =
            actor['url_small_image']?.toString() ?? '';

        return Container(
          height: 88,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 65,
                  height: 70,
                  child: movieImage(image),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name : $name',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Character : $character',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget genresSection(List<dynamic> genres) {
    if (genres.isEmpty) {
      return const Text(
        'No genres available',
        style: TextStyle(color: Colors.white54),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: genres.map((genre) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            genre.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildMovieContent(
      Map<String, dynamic> movie,
      List<Map<String, dynamic>> suggestions,
      ) {
    final String title =
        movie['title']?.toString() ?? '';

    final String year =
        movie['year']?.toString() ?? '';

    final String rating =
        movie['rating']?.toString() ?? '0';

    final String runtime =
        movie['runtime']?.toString() ?? '0';

    final String likes =
        movie['like_count']?.toString() ?? '0';

    final String poster =
    movie['large_cover_image']?.toString().isNotEmpty == true
        ? movie['large_cover_image'].toString()
        : movie['medium_cover_image']?.toString() ?? '';

    final String summary =
    movie['description_full']?.toString().isNotEmpty == true
        ? movie['description_full'].toString()
        : movie['summary']?.toString() ?? '';

    final List<dynamic> screenshots = [
      movie['medium_screenshot_image1'],
      movie['medium_screenshot_image2'],
      movie['medium_screenshot_image3'],
    ].where(
          (image) =>
      image != null && image.toString().isNotEmpty,
    ).toList();

    final List<dynamic> genres =
    movie['genres'] is List ? movie['genres'] : [];

    final List<dynamic> cast =
    movie['cast'] is List ? movie['cast'] : [];

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 520,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              12, 22, 12, 35,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 0.85,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      movieImage(poster),

                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 0.35, 0.65, 1.0],
                            colors: [
                              Color(0x44000000),
                              Color(0x08000000),
                              Color(0xBB000000),
                              Color(0xFF111111),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        top: 8,
                        left: 5,
                        child: IconButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Positioned(
                        top: 8,
                        right: 5,
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
                            size: 30,
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 22,
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
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              year,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Watch',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    statCard(Icons.favorite, likes),
                    statCard(Icons.access_time_filled, runtime),
                    statCard(Icons.star, rating),
                  ],
                ),

                const SizedBox(height: 25),


                sectionTitle('Screen Shots'),
                screenshotSection(screenshots),

                const SizedBox(height: 25),

                sectionTitle('Similar'),
                similarMovies(suggestions),

                const SizedBox(height: 25),


                sectionTitle('Summary'),
                Text(
                  summary.isEmpty
                      ? 'No summary available.'
                      : summary,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.55,
                  ),
                ),

                const SizedBox(height: 25),

                // Cast
                sectionTitle('Cast'),
                castSection(cast),

                const SizedBox(height: 15),

                sectionTitle('Genres'),
                genresSection(genres),
              ],
            ),
          ),
        ),
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
              alignment: Alignment.center,
              child: const Text(
                'Movies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ),

            Expanded(
              child: BlocBuilder<
                  MovieDetailsCubit,
                  MovieDetailsState>(
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
                          mainAxisSize: MainAxisSize.min,
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
                    return const Center(
                      child: Text(
                        'Movie not found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return buildMovieContent(
                    movie,
                    state.suggestions,
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
