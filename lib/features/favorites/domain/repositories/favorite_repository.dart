import '../entities/favorite_item.dart';

abstract class FavoritesRepository {

  List<FavoriteItem> getFavorites();

  void addFavorite(FavoriteItem item);

  void removeFavorite(FavoriteItem item);

}