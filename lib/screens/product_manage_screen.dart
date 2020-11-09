import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/logic/sizes_helpers.dart';
import 'package:shop_app/providers/product.dart';

import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class ProductManageScreen extends StatefulWidget {
  @override
  _ProductManageScreenState createState() => _ProductManageScreenState();
}

class _ProductManageScreenState extends State<ProductManageScreen> {
  bool isLoading = true;
  bool init = true;

  Future<void> refreshItems(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetData(isFilteredByUser: true);
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    print('ProductManageScreen: didChangeDependencies');
    if (init) {
      isLoading = true;
      try {
         Provider.of<Products>(context, listen: true).fetchAndSetData(isFilteredByUser: true).then(
                 (value) {
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
    print('Build: ProductManageScreen');
    //Products myProducts = Provider.of<Products>(context);
    var idWidth = MediaQuery.of(context).size.width / 3;
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: AutoSizeText(
          'Product manage page',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          wrapWords: true,
          minFontSize: 0,
          stepGranularity: 0.1,
        ),
        actions: [
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.add),
            onPressed: () {
              // add new product...
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProductScreen(
                        addingBehavior: true,
                      )));
            },
          )
        ],
      ),
      body: isLoading?Center(child: CircularProgressIndicator(),):RefreshIndicator(
        onRefresh: () {
          //async{
          //return await Provider.of<Products>(context,listen: false).fetchAndSetData();
          return refreshItems(context);
        },
        child: Consumer<Products>(
          builder: (ctx, myProducts, child) => Container(
            child: ListView(
                children: myProducts.authorItems
                    .map((e) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          ListTile(
                            title: AutoSizeText(
                              e.title,
                              maxLines: 1,
                              style: TextStyle(fontSize: 20),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              wrapWords: true,
                              minFontSize: 10,
                              stepGranularity: 0.1,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(e.imageUrl),
                              //CachedNetworkImageProvider(e
                              // .imageUrl),
                            ),
                            trailing: Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                Container(
                                  width: displayWidth(context) * 0.18,
                                  child: SizedBox.expand(
                                    child: Center(
                                      child: AutoSizeText(
                                        '\$${e.price.toStringAsFixed(2)}',
                                        //presetFontSizes: [ 16, 18, 20],
                                        stepGranularity: 0.1,
                                        minFontSize: 0,
                                        style: TextStyle(color: Colors.green[800], fontSize: 18),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textScaleFactor:
                                            (e.price.toString().characters.length >= 8) ? 0.8 : 1,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.all(0),
                                  visualDensity: VisualDensity.adaptivePlatformDensity,
                                  icon: Icon(Icons.edit),
                                  iconSize: 25,
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => EditProductScreen(
                                              addingBehavior: false,
                                              oldProductID: e.id,
                                            )));
                                  },
                                ),
                                IconButton(
                                  padding: EdgeInsets.all(0),
                                  visualDensity: VisualDensity.adaptivePlatformDensity,
                                  icon: Icon(Icons.delete),
                                  iconSize: 25,
                                  color: Theme.of(context).errorColor,
                                  onPressed: () async {
                                    int index = myProducts.authorItems
                                        .indexWhere((element) => element.id == e.id);
                                    Product item = myProducts.authorItems.elementAt(index);
                                    await Provider.of<Products>(context, listen: false)
                                        .deleteItem(e.id)
                                        .then((value) {
                                      scaffoldKey.currentState.showSnackBar(SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text('${e.title} is deleted'),
                                          action: SnackBarAction(
                                              label: 'UNDO',
                                              onPressed: () async {
                                                await Provider.of<Products>(context, listen: false)
                                                    .addItem(item, index: index);
                                              })));
                                    }).catchError((e) {
                                      scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text('Failed deleting'),
                                      ));
                                    });
                                  },
                                )
                              ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: AutoSizeText(
                              "${e.id}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0.6
                                  //fontFamily: 'Lato-Bold',
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              wrapWords: true,
                              minFontSize: 10,
                              stepGranularity: 0.1,
                            ),
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                        ]))
                    .toList()),
          ),
        ),
      ),
    );
  }
}
