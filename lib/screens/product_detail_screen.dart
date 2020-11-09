import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
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
    String url = args['url'];

    //Product myProduct =Provider.of<Products>(context).items.firstWhere((element) => element
    // .id==productId);
    //Product myProduct = Provider.of<Product>(context);
    return Scaffold(
      drawer: AppDrawer(
      ),
        appBar:AppBar(title: AutoSizeText(title,
          maxLines: 1,
          style: TextStyle(fontSize: 30),

          overflow: TextOverflow.ellipsis,
          softWrap: true,
          wrapWords: true,
          minFontSize: 0,
          stepGranularity: 0.1,

        ),),
        body: Container(child:SingleChildScrollView(
          child: Column(children: [
            Container(
              width: double.infinity,
              height: 350,
             child: Image.network(url,fit: BoxFit.cover,),

            ),
            SizedBox(height: 10,)
            ,Text(id),
            Text(description)
          ],),
        ),),
        );
  }
}
