import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/logic/sizes_helpers.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // ProductItem({this.id, this.imageUrl, this.title});

  @override
  Widget build(BuildContext context) {
    Product myProduct = Provider.of<Product>(context, listen: false);
    Cart myCart = Provider.of<Cart>(context, listen: false);
    Auth myAuthData =Provider.of<Auth>(context, listen: false);
    print('build prodItem');
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'product-details', arguments: {
          'id': myProduct.id,
          'title': myProduct.title,
          'description': myProduct.description,
          'url': myProduct.imageUrl
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: //Image.network(myProduct.imageUrl,),//CachedNetworkImage(imageUrl: myProduct
          //.imageUrl,),
        SizedBox(
          width: displayWidth(context)*0.45,
          height: displayHeight(context)*0.25,
          // child: CachedNetworkImage(
          //     imageUrl: myProduct.imageUrl,
          //    imageBuilder: (context, imageProvider){
          //       return Image(image: imageProvider,);
          //    },
          //     placeholder: (context, url) => Container(
          //       child: Center(child: CircularProgressIndicator()),
          //       margin: EdgeInsets.all(10),
          //       padding: EdgeInsets.all(10),
          //     ),
          //     fit: BoxFit.fill,
          //     filterQuality: FilterQuality.high,
          //   ),
          child: Image.network(myProduct.imageUrl),
        ),
          footer: GridTileBar(

            title: AutoSizeText(
              myProduct.title,
              textAlign: TextAlign.center,
              minFontSize:8,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              wrapWords: true,

              stepGranularity: 0.5,
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18 ),
            ),
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
            leading: Consumer<Product>(
              builder: (context, product, child) => IconButton(
                icon: Icon(
                  myProduct.isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red[500],
                ),
                onPressed: () {
                  myProduct.toggleFavButton(myAuthData.token,myAuthData.userId);
                },
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.add_shopping_cart,
                color: Colors.limeAccent[700],
                size: 30,
              ),
              onPressed: () {
                myCart.addItem(myProduct.id, myProduct.price, myProduct.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Item has been added '
                    'to the cart',
                    textAlign: TextAlign.center,
                  ),
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        myCart.deleteSingleQuantity(myProduct.id);
                      }),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
