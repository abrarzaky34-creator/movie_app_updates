class OnboardingItem {
  final String imagePath;
  final String? title;
  final String? description;
  final String primaryButtonText;
  final bool showBackButton;

  const OnboardingItem({
    required this.imagePath,
    this.title,
    this.description,
    required this.primaryButtonText,
    required this.showBackButton,
  });
}

final List<OnboardingItem> onboardingItems = [
  const OnboardingItem(
    imagePath: 'assets/images/onboarding_1.png',
    title: 'Find Your Next Favorite Movie Here',
    description:
    'Get access to a huge library of movies to suit all tastes. You will surely like it.',
    primaryButtonText: 'Explore Now',
    showBackButton: false,
  ),
  const OnboardingItem(
    imagePath: 'assets/images/onboarding_2.png',
    title: 'Discover Movies',
    description:
    'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',
    primaryButtonText: 'Next',
    showBackButton: true,
  ),
  const OnboardingItem(
    imagePath: 'assets/images/onboarding_3.png',
    title: 'Explore All Genres',
    description:
    'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
    primaryButtonText: 'Next',
    showBackButton: true,
  ),
  const OnboardingItem(
    imagePath: 'assets/images/onboarding_4.png',
    title: 'Create Watchlists',
    description:
    'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.',
    primaryButtonText: 'Next',
    showBackButton: true,
  ),
  const OnboardingItem(
    imagePath: 'assets/images/onboarding_5.png',
    title: 'Rate, Review, and Learn',
    description:
    "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
    primaryButtonText: 'Next',
    showBackButton: true,
  ),
  const OnboardingItem(
    imagePath: 'assets/images/onboarding_6.png',
    title: 'Start Watching Now',
    description: null,
    primaryButtonText: 'Finish',
    showBackButton: true,
  ),
];