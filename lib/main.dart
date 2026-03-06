import 'package:flutter/material.dart';
import 'package:naayu_attire1/app.dart';
import 'package:naayu_attire1/core/api/api_client.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import 'package:naayu_attire1/core/providers/theme_provider.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';
import 'package:naayu_attire1/core/services/connectivity/network_info.dart';
import 'package:naayu_attire1/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:naayu_attire1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:naayu_attire1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:naayu_attire1/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:naayu_attire1/features/dashboard/presentation/provider/flash_product_provider.dart';
import 'package:naayu_attire1/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:naayu_attire1/features/cart/presentation/provider/cart_provider.dart';
import 'package:naayu_attire1/features/favorites/presentation/provider/favorites_provider.dart';
import 'package:naayu_attire1/features/category/presentation/provider/product_provider.dart';
import 'package:naayu_attire1/features/category/domain/usecases/get_products.dart';
import 'package:naayu_attire1/features/category/data/repositories/product_repository_impl.dart';
import 'package:naayu_attire1/features/category/data/datasources/product_remote_datasource.dart';
import 'package:naayu_attire1/features/notification/data/datasource/notification_remote_datasource.dart';
import 'package:naayu_attire1/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:naayu_attire1/features/notification/domain/usecases/mark_notification_read_usecase.dart';
import 'package:naayu_attire1/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:naayu_attire1/features/category/data/models/product_model.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///FIREBASE
  await Firebase.initializeApp();

  /// HIVE INITIALIZATION
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());

  await Hive.openBox("cartBox");
  await Hive.openBox("wishlistBox");
  await Hive.openBox("authBox");

  await Hive.openBox<ProductModel>("productsBox");
  await Hive.openBox("notificationBox");

  FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  
  final sharedPreferences = await SharedPreferences.getInstance();
  final tokenService = TokenService(sharedPreferences);
  final apiClient = ApiClient(tokenService);

  final networkInfo = NetworkInfo(Connectivity());

  final authDatasource = AuthRemoteDatasourceImpl(apiClient);
  final authRepository = AuthRepositoryImpl(authDatasource);

  final notificationDatasource =
    NotificationRemoteDatasource(apiClient.dio);

final notificationRepository =
    NotificationRepositoryImpl(notificationDatasource);

final getNotificationsUsecase =
    GetNotificationsUsecase(notificationRepository);

final markNotificationReadUsecase =
    MarkNotificationReadUsecase(notificationRepository);


  bool isLoggedIn = false;

  runApp(
    MultiProvider(
      providers: [

     
        Provider<TokenService>(
          create: (_) => tokenService,
        ),

       
        ChangeNotifierProvider(
          create: (_) =>
              AuthViewModel(authRepository, tokenService),
        ),

       ChangeNotifierProvider(
  create: (_) => CartProvider(CartRepositoryImpl()),

),
ChangeNotifierProvider(
    create: (_) => FavoritesProvider(),
  ),

  ChangeNotifierProvider(
  create: (_) => ProductProvider(
    GetProducts(
      ProductRepositoryImpl(
        ProductRemoteDatasource(apiClient.dio)
      ),
    ),
  ),
),

        
        ChangeNotifierProvider(
          lazy: false,
          create: (_) {
            final provider =
                ShopProvider(tokenService, apiClient, networkInfo);

            Future.microtask(() async {
              await provider.initializeUser();
            });

            return provider;
          },
        ),

        /// THEME
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

        /// FLASH PRODUCTS
        ChangeNotifierProvider(
          create: (_) => FlashProductProvider(),
        ),
        ChangeNotifierProvider(
  create: (_) => NotificationViewModel(
    getNotificationsUsecase,
    markNotificationReadUsecase,
  ),
),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}