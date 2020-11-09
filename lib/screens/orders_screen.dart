import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isInit = true;
  bool isLoading = false;

  // @override
  // void didChangeDependencies() {
  //   if (isInit) {
  //     isLoading = true;
  //     try {
  //       Provider.of<Orders>(context).fetchAndSetData();
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  //   isLoading = false;
  //   isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    print('Build: OrderScreen');
    //Orders orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: AutoSizeText(
          'Your orders',
          maxLines: 1,
          style: TextStyle(fontSize: 30),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          wrapWords: true,
          minFontSize: 0,
          stepGranularity: 0.1,
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Text('Some error Occured');
            } else {
              return Consumer<Orders>(
                builder: (ctx,orderData,ch){
                  return ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (context, index) => OrderItem(
                        id: orderData.orders[index].id,
                        amount: orderData.orders[index].amount,
                        order: orderData.orders[index],
                      ));
                },
              );
            }
          }
        },
      ),
      // isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : ListView.builder(
      //         itemCount: orderData.orders.length,
      //         itemBuilder: (context, index) => OrderItem(
      //               id: orderData.orders[index].id,
      //               amount: orderData.orders[index].amount,
      //               order: orderData.orders[index],
      //             )),
    );
  }
}
