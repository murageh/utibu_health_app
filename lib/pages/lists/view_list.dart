// will be used to render the list of items in the list
// lists: users, medication, prescriptions, orders, order_history
// accepts a list of items and a title
// displays the list of items in a ListView
// list is divided into ListTile widgets

import 'package:flutter/material.dart';

// an item has a title, a subtitle, and an icon, and an onTap event
// the onTap event is used to navigate to the item details page
// the trailing icon is used to indicate that the item is clickable
// the trailing icon is by default an arrow pointing to the right
// the trailing icon can be customized
class Item {
  final String title;
  final String subtitle;
  final String? thirdLine;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  static void _defaultOnTap() {}

  const Item({
    required this.title,
    required this.subtitle,
    this.thirdLine,
    this.icon = Icons.arrow_forward_ios,
    this.onTap = _defaultOnTap,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
  });
}

class ViewList extends StatelessWidget {
  final List<Item> items;
  final String title;

  const ViewList({
    super.key,
    required this.items,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].title),
            isThreeLine: items[index].thirdLine != null,
            subtitle: Text(
                items[index].subtitle + (items[index].thirdLine != null ? '\n${items[index].thirdLine}' : '')
            ),
            onTap: items[index].onTap,
            trailing: Icon(items[index].icon),
            tileColor: items[index].backgroundColor,
            titleTextStyle: TextStyle(color: items[index].foregroundColor),
            subtitleTextStyle: TextStyle(color: items[index].foregroundColor),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(indent: 16, endIndent: 16, height: 0,);
        },
        itemCount: items.length,
      ),
    );
  }
}
