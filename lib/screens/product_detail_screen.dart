import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/logic/sizes_helpers.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Build: ProductDetailScree');
    Map args = ModalRoute.of(context).settings.arguments as Map;
    String id = args['id'];
    String title = args['title'];
    String description = args['description'];
    //final price = args['price'];
    String url = args['url'];

    //Product myProduct =Provider.of<Products>(context).items.firstWhere((element) => element
    // .id==productId);
    //Product myProduct = Provider.of<Product>(context);
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
          // appBar: AppBar(
          //   title: AutoSizeText(
          //     title,
          //     maxLines: 1,
          //     style: TextStyle(fontSize: 30),
          //     overflow: TextOverflow.ellipsis,
          //     softWrap: true,
          //     wrapWords: true,
          //     minFontSize: 0,
          //     stepGranularity: 0.1,
          //   ),
          // ),
          body: Container(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: backgroundColor,
                  expandedHeight: displayHeight(context)*0.65,
                  pinned: true,
                  centerTitle: true,
                  bottom: PreferredSize(
                    preferredSize: Size(double.infinity,kTextTabBarHeight),
                    child: Container(
                      width: double.infinity,
                      color: Colors.black54,
                      child: AutoSizeText(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(fontSize: 30, color: textColor),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        wrapWords: true,
                        minFontSize: 0,
                        stepGranularity: 0.1,
                      ),
                    ),
                  ),

                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                        tag: id,
                        child: Image(
                          image: CachedNetworkImageProvider(
                            url,
                          ),
                          fit: BoxFit.cover,

                        )),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 10,
                    ),
                    Text(id),
                    //Text(price),
                    Text(description)
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
