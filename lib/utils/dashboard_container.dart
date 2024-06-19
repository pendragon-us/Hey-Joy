import 'package:flutter/material.dart';

class DashboardContainer extends StatefulWidget {

  final Color containerColor;
  final String filePath;
  final String containerName;
  final Function()? onTap;

  const DashboardContainer({super.key, required this.containerColor, required this.filePath, required this.containerName, this.onTap});

  @override
  State<DashboardContainer> createState() => _DashboardContainerState();
}

class _DashboardContainerState extends State<DashboardContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.containerColor,
        ),
        margin: EdgeInsets.all(5),
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                image: AssetImage(widget.filePath),
            ),
            Divider(
              color: Colors.white,
              thickness: 2,
              endIndent: 20,
              indent: 20,
            ),
            Text(
              widget.containerName,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
