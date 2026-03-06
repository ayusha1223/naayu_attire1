import 'package:hive/hive.dart';
import 'package:naayu_attire1/features/favorites/domain/repositories/favorite_repository.dart';
import '../../domain/entities/favorite_item.dart';


class FavoritesRepositoryImpl implements FavoritesRepository {

  final Box box;

  FavoritesRepositoryImpl(this.box);

  @override
  List<FavoriteItem> getFavorites() {
    return box.values.cast<FavoriteItem>().toList();
  }

  @override
  void addFavorite(FavoriteItem item) {
    box.put(item.id, item);
  }

  @override
  void removeFavorite(FavoriteItem item) {
    box.delete(item.id);
  }
}