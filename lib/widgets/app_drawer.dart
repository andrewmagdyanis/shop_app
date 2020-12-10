import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/logic/sizes_helpers.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_manage_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color iconColor = Colors.red[600];
    Color textColor = Colors.yellow[800];
    Color backGroundColor = Colors.yellow[200];
    return Drawer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Center(
                child: Text(
              'App Navigator',
              style: TextStyle(color: Colors.deepOrange[700]),
            )),
            automaticallyImplyLeading: false,
          ),
          body: Container(
            padding: EdgeInsets.all(5),
            child: ListView(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              children: [
                Divider(
                  thickness: 2,
                  color: Colors.red[900],
                ),
                FlatButton.icon(
                  padding: EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  height: MediaQuery.of(context).size.height * 0.1,
                  icon: Icon(
                    Icons.store,
                    size: 30,
                    color: iconColor,
                  ),
                  label: Container(
                    width: displayWidth(context)/1.9,
                    child: AutoSizeText('Shop',
                      textAlign: TextAlign.center,

                      maxLines: 1,
                      style: TextStyle(fontSize: 30,color: textColor),
                      overflow: TextOverflow.ellipsis,
                      maxFontSize: 30,
                      softWrap: true,
                      wrapWords: true,
                      minFontSize: 15,
                      stepGranularity: 0.1,

                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    //Navigator.popUntil(context, (route) => route.isFirst);
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //   builder: (context)=> ProductOverviewScreen()
                    // ));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => ProductOverviewScreen()), (route) {
                      print('Removed: ' + route.settings.name.toString());
                      return route.isFirst;
                    });
                  },
                ),
                Divider(
                  height: 0,
                  thickness: 0,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.black,
                ),
                FlatButton.icon(
                  padding: EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  height: MediaQuery.of(context).size.height * 0.1,
                  icon: Icon(
                    Icons.shopping_cart_sharp,
                    size: 30,
                    color: iconColor,
                  ),
                  label:Container(
                    width: displayWidth(context)/1.9,
                    child: AutoSizeText('Cart',
                      textAlign: TextAlign.center,

                      maxLines: 1,
                      style: TextStyle(fontSize: 30,color: textColor),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      wrapWords: true,
                      minFontSize: 0,
                      stepGranularity: 0.1,

                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => CartScreen()), (route) {
                      print('Removed: ' + route.settings.name.toString());
                      return route.isFirst;
                    });
                    // .push(MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                ),
                Divider(
                  height: 0,
                  thickness: 0,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.black,
                ),
                FlatButton.icon(
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    height: MediaQuery.of(context).size.height * 0.1,
                    icon: Icon(
                      Icons.filter,
                      size: 30,
                      color: iconColor,
                    ),
                    label: Container(
                      width: displayWidth(context)/1.9,
                      child: AutoSizeText('Orders',
                        textAlign: TextAlign.center,

                        maxLines: 1,
                        style: TextStyle(fontSize: 30,color: textColor),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        wrapWords: true,
                        minFontSize: 0,
                        stepGranularity: 0.1,

                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => OrderScreen()), (route) {
                        print('Removed: ' + route.settings.name.toString());
                        return route.isFirst;
                      });
                    }),
                Divider(
                  height: 0,
                  thickness: 0,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.black,
                ),
                FlatButton.icon(
                  padding: EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  height: MediaQuery.of(context).size.height * 0.1,
                  icon: Icon(
                    Icons.architecture_sharp,
                    size: 30,
                    color: iconColor,
                  ),
                  label: Container(
                    width: displayWidth(context)/1.9,
                    child: AutoSizeText('Product Mange',
                      textAlign: TextAlign.center,

                      maxLines: 1,
                      style: TextStyle(fontSize: 30,color: textColor),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      wrapWords: true,
                      minFontSize: 0,
                      stepGranularity: 0.1,

                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => ProductManageScreen()), (route) {
                      print('Removed: ' + route.settings.name.toString());
                      return route.isFirst;
                    });
                  },
                ),
                Divider(
                  height: 0,
                  thickness: 0,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.black,
                ),
                FlatButton.icon(
                  padding: EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  height: MediaQuery.of(context).size.height * 0.1,
                  icon: Icon(
                    Icons.exit_to_app_rounded,
                    size: 30,
                    color: iconColor,
                  ),
                  label: Container(
                    width: displayWidth(context)/1.9,
                    child: AutoSizeText('Logout',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(fontSize: 30,color: textColor),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      wrapWords: true,
                      minFontSize: 0,
                      stepGranularity: 0.1,

                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();//close drawer
                    //Navigator.of(context).pushNamed('/');
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                ),
                Divider(
                  height: 0,
                  thickness: 0,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
