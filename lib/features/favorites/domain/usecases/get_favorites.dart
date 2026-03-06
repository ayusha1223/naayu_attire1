import 'package:naayu_attire1/features/favorites/domain/repositories/favorite_repository.dart';

import '../entities/favorite_item.dart';

class GetFavorites {

  final FavoritesRepository repository;

  GetFavorites(this.repository);

  List<FavoriteItem> call() {
    return repository.getFavorites();
  }
}