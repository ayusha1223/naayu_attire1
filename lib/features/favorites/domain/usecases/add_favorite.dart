import 'package:naayu_attire1/features/favorites/domain/repositories/favorite_repository.dart';

import '../entities/favorite_item.dart';


class AddFavorite {

  final FavoritesRepository repository;

  AddFavorite(this.repository);

  void call(FavoriteItem item) {
    repository.addFavorite(item);
  }
}