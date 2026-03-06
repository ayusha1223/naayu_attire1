import 'package:naayu_attire1/features/favorites/domain/repositories/favorite_repository.dart';

import '../entities/favorite_item.dart';


class RemoveFavorite {

  final FavoritesRepository repository;

  RemoveFavorite(this.repository);

  void call(FavoriteItem item) {
    repository.removeFavorite(item);
  }
}