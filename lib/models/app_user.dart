class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String avatar; // asset path or URL, e.g. 'assets/images/avatar_1.png'
  final List<int> favorites;
  final List<int> watchedMovies;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    this.favorites = const [],
    this.watchedMovies = const [],
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      avatar: map['avatar'] ?? 'assets/images/avatar_1.png',
      favorites: (map['favorites'] as List?)?.cast<int>() ?? [],
      watchedMovies: (map['watchedMovies'] as List?)?.cast<int>() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'favorites': favorites,
      'watchedMovies': watchedMovies,
    };
  }

  AppUser copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatar,
    List<int>? favorites,
    List<int>? watchedMovies,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      favorites: favorites ?? this.favorites,
      watchedMovies: watchedMovies ?? this.watchedMovies,
    );
  }
}
