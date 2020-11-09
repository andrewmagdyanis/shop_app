import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';

import 'components/thems.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Size size = window.physicalSize;
    double devicePixelRatio = window.devicePixelRatio;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          update: (context, auth, prevCart) => Cart(idToken: auth.token, prevCart: prevCart),
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, prevProducts) =>
              Products(idToken: auth.token, prevProducts: prevProducts, userId: auth.userId),
          create: (context) => Products(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, prevOrders) =>
              Orders(idToken: auth.token, prevOrders: prevOrders, userId: auth.userId),
          create: (context) => Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          return MaterialApp(
            title: 'ShopApp',
            debugShowCheckedModeBanner: false,
            theme: Themes(size: size, aspectRatio: devicePixelRatio).themeDataProvider('light'),
            darkTheme: Themes(size: size, aspectRatio: devicePixelRatio).themeDataProvider('dark'),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),

            routes: <String, WidgetBuilder>{
              'product-overview': (BuildContext context) => ProductOverviewScreen(),
              'product-details': (BuildContext context) => ProductDetailScreen(),
            },
          );
        },
      ),
    );
  }
}
