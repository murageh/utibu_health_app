import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/components/app_bar.dart';
import 'package:utibu_health_app/models/order.dart';
import 'package:utibu_health_app/models/user.dart';
import 'package:utibu_health_app/pages/lists/view_list.dart';
import 'package:utibu_health_app/pages/login_page.dart';
import 'package:utibu_health_app/providers/identity/Identityprovider.dart';
import 'package:utibu_health_app/services/api_service.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<Order> orders = [];

  void getOrders(String? token) async {
    await ApiService().getOrders(token).then((value) {
      setState(() {
        orders = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    IdentityProvider identityProvider =
        Provider.of<IdentityProvider>(context, listen: false);
    getOrders(identityProvider.identity?['token']);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IdentityProvider>(
        builder: (context, identityProvider, child) {
      if (!identityProvider.isLoggedIn) {
        return const LoginPage();
      }
      return Scaffold(
        appBar: buildAppBar(
          context,
          'Orders',
        ),
        body: ViewList(
          title: 'Orders',
          items: orders
              .map((order) => Item(
                  title: '${order.orderDate}',
                  subtitle: '${order.orderStatus}:${order.paymentStatus}',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Order Details'),
                          content: Column(
                            children: <Widget>[
                              Text('Order ID: ${order.orderId}'),
                              Text('Order Date: ${order.orderDate}'),
                              Text('Order Status: ${order.orderStatus}'),
                              Text('Payment Status: ${order.paymentStatus}'),
                              Text('Prescription: ${order.prescription.prescriptionId}'),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  }))
              .toList(),
        ),
      );
    });
  }
}
