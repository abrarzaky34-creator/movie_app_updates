import 'package:flutter/material.dart';
import 'update_profile_screen.dart' show UpdateProfileScreen;
import 'login_screen.dart' show LoginScreen;

class AppColors {
  static const Color background = Color(0xFF121312);
  static const Color primary = Color(0xFFF6BD00);
  static const Color fieldFill = Color(0xFF282A28);
  static const Color fieldBorder = Color(0xFF282A28);
  static const Color fieldBorderFocused = Color(0xFF2F80ED);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color danger = Color(0xFFE53935);
}


class MovieItem {
  final String title;
  final double rating;

  const MovieItem({required this.title, this.rating = 7.7});
}

final List<MovieItem> _dummyMovies = List.generate(
  14,
      (index) => MovieItem(title: 'Movie ${index + 1}'),
);

final List<String> _dummyCategories = const [
  'Action',
  'Adventure',
  'Animation',
  'Biography',
  'Comedy',
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    _HomeTab(),
    _SearchTab(),
    _BrowseTab(),
    _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}



class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.local_activity_outlined,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.fieldFill, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_icons.length, (index) {
          final bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _icons[index],
                color: isSelected ? Colors.black : AppColors.textGrey,
                size: 24,
              ),
            ),
          );
        }),
      ),
    );
  }
}



class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      children: [
        Center(
          child: Image.asset(
            'assets/images/available_now.png',
            width: 267,
            height: 93,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 20),
        _FeaturedCarousel(movies: _dummyMovies),

        const SizedBox(height: 24),

        Center(
          child: GestureDetector(
            onTap: () {},
            child: Image.asset(
              'assets/images/watch_now.png',
              width: 180,
              height: 64,
              fit: BoxFit.contain,
            ),
          ),
        ),

        const SizedBox(height: 28),

        ..._dummyCategories.map(
              (category) => _CategorySection(title: category),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final MovieItem movie;
  final double width;
  final double height;

  const _FeaturedCard({
    required this.movie,
    this.width = 234,
    this.height = 351,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.movie_creation_outlined,
              color: AppColors.textGrey,
              size: 56,
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: _RatingBadge(rating: movie.rating),
          ),
        ],
      ),
    );
  }
}


class _FeaturedCarousel extends StatefulWidget {
  final List<MovieItem> movies;

  const _FeaturedCarousel({required this.movies});

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  late final PageController _pageController;
  double _page = 0;

  static const double _viewportFraction = 0.6;
  static const double _gap = 12;
  static const double _cardHeight = 351;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: _viewportFraction);
    _page = 0;
    _pageController.addListener(() {
      setState(() {
        _page = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double pageWidth = constraints.maxWidth * _viewportFraction;
          final double cardWidth = pageWidth - _gap;

          return PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.movies.length,
            itemBuilder: (context, index) {
              final double distance = (index - _page).abs().clamp(0.0, 1.0);
              final double opacity = 1 - (distance * 0.5); // side: ~0.5

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: _gap / 2),
                child: Opacity(
                  opacity: opacity,
                  child: _FeaturedCard(
                    movie: widget.movies[index],
                    width: cardWidth,
                    height: _cardHeight,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String title;

  const _CategorySection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'See More →',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _dummyMovies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return _MovieCard(movie: _dummyMovies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}


class _SearchTab extends StatefulWidget {
  const _SearchTab();

  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textWhite, fontSize: 14),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.fieldFill,
                hintText: 'Search',
                hintStyle: const TextStyle(color: AppColors.textGrey),
                prefixIcon: const Icon(Icons.search, color: AppColors.textWhite),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _MovieGrid(movies: _dummyMovies),
          ),
        ],
      ),
    );
  }
}

class _BrowseTab extends StatefulWidget {
  const _BrowseTab();

  @override
  State<_BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<_BrowseTab> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _dummyCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final bool isSelected = index == _selectedCategory;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.fieldFill,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _dummyCategories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.black : AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _MovieGrid(movies: _dummyMovies),
          ),
        ),
      ],
    );
  }
}


class _ProfileTab extends StatefulWidget {
  const _ProfileTab();

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  bool _showWatchList = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.fieldFill,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.textGrey,
                  size: 36,
                ),
              ),
              const _ProfileStat(label: 'Wish List', value: '0'),
              const _ProfileStat(label: 'History', value: '0'),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'User Name',
            style: TextStyle(
              color: AppColors.textWhite,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdateProfileScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                            (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text(
                      'Exit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _ProfileTabButton(
                  label: 'Watch List',
                  icon: Icons.list_alt,
                  isSelected: _showWatchList,
                  onTap: () => setState(() => _showWatchList = true),
                ),
              ),
              Expanded(
                child: _ProfileTabButton(
                  label: 'History',
                  icon: Icons.folder_outlined,
                  isSelected: !_showWatchList,
                  onTap: () => setState(() => _showWatchList = false),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(color: AppColors.fieldFill, height: 1),

          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_movies_outlined,
                    color: AppColors.textGrey,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _showWatchList ? 'Your watch list is empty' : 'No history yet',
                    style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
        ),
      ],
    );
  }
}

class _ProfileTabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProfileTabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected ? AppColors.primary : AppColors.textGrey;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }
}



class _MovieGrid extends StatelessWidget {
  final List<MovieItem> movies;

  const _MovieGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) => _MovieCard(movie: movies[index]),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final MovieItem movie;

  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.movie_outlined,
                      color: AppColors.textGrey,
                      size: 32,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _RatingBadge(rating: movie.rating),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toString(),
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.star, color: AppColors.primary, size: 11),
        ],
      ),
    );
  }
}