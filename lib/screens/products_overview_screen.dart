import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_item.dart';

enum FilterOption { ShowFav, ShowAll }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showFavOnly = false;
  bool init = true;
  bool isLoading = false;

  Future<void> refreshItems(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetData(isFilteredByUser: false);
  }

  @override
  void didChangeDependencies() {
    print('productOverviewScreen: didChangeDependencies');
    if (init) {
      isLoading = true;
      try {
        Provider.of<Products>(context, listen: true)
            .fetchAndSetData(isFilteredByUser: false)
            .then((value) {
          isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('Build: ProductsOverviewScreen');
    //List<Product>loadedProducts = Provider.of<Products>(context).items;

    // final productContainer = Provider.of<Products>(context, listen: false);
    List<Product> loadedProducts = (showFavOnly)
        ? Provider.of<Products>(context).favItems
        : Provider.of<Products>(context).items;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: AutoSizeText(
          'Shop overview',
          maxLines: 1,
          style: TextStyle(fontSize: 30),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          wrapWords: true,
          minFontSize: 0,
          stepGranularity: 0.1,
        ),
        actions: [
          Consumer(
            builder: (context, Cart cart, ch) => Badge(
              value: cart.cartCount,
              child: ch,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              iconSize: 30,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              size: 30,
            ),
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.ShowFav) {
                  showFavOnly = true;
                  //Provider.of<Products>(context, listen: false).showFav();
                } else {
                  showFavOnly = false;
                  //Provider.of<Products>(context, listen: false).showAll();
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: FilterOption.ShowFav, child: Text('Show Favourite')),
              PopupMenuItem(value: FilterOption.ShowAll, child: Text('Show All'))
            ],
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                return refreshItems(context);
              },
              child: GridView.builder(
                  itemCount: loadedProducts.length,
                  padding: EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ChangeNotifierProvider.value(
                      value: loadedProducts[index],
                      child: ProductItem(
                          // id: loadedProducts[index].id,
                          // title: loadedProducts[index].title,
                          // imageUrl: loadedProducts[index].imageUrl,
                          ),
                    );
                  }),
            ),
    );
  }
}

class GridBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    List<Product> loadedProducts = productsData.items;
    print('build the grid');
    return GridView.builder(
        itemCount: loadedProducts.length,
        padding: EdgeInsets.all(5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ChangeNotifierProvider.value(
            value: loadedProducts[index],
            child: ProductItem(
                // id: loadedProducts[index].id,
                // title: loadedProducts[index].title,
                // imageUrl: loadedProducts[index].imageUrl,
                ),
          );
        });
  }
}
