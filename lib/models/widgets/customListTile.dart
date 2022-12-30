import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  final IconData leadingIcon;
  final String title;
  final Widget? child;
  final Widget trailing;
  final BuildContext context;
  final Function? onTap;
  final Function onTapTrailing;
  const CustomListTile(
      {super.key,
      required this.leadingIcon,
      required this.title,
      this.child,
      required this.trailing,
      required this.context,
      required this.onTap,
      required this.onTapTrailing});

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  final double borderRadius = 15;

  final double borderWidth = 2;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (widget.onTap == null) ? null : () => widget.onTap!(),
      child: Container(
        // padding: (padding == null) ? const EdgeInsets.all(0.0) : padding,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Leading icon
                Icon(
                  widget.leadingIcon,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ),
                //Title
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Text(widget.title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ))),
                //Trailing icon button
                InkWell(
                  onTap: () => widget.onTapTrailing(),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10),
                    //   color: Theme.of(context).primaryColor,
                    // ),
                    child: widget.trailing,
                  ),
                ),
              ],
            ),
            (widget.child == null)
                ? SizedBox(
                    height: 0,
                  )
                : Container(
                    margin: EdgeInsets.only(top: 10),
                    child: widget.child,
                  ),
          ],
        ),
      ),
    );
  }
}
