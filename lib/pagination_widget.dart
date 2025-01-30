import 'package:flutter/material.dart';

class PaginationWidget extends StatefulWidget {
  final Function(int) onPageChanged;
  final int currentPage;

  const PaginationWidget({
    super.key,
    required this.onPageChanged,
    required this.currentPage,
  });

  @override
  State<PaginationWidget> createState() => _PaginationWidgetState();
}
class _PaginationWidgetState extends State<PaginationWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          onPressed: widget.currentPage > 1
              ? () {
                  widget.onPageChanged(widget.currentPage - 1);
                }
              : null,
          child: const Column(
            children: [
              Text("Previous Page"),
              Icon(Icons.arrow_back_ios),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Page ${widget.currentPage}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        MaterialButton(
          onPressed: widget.currentPage <
                  ((widget.currentPage - 1) * 8 +
                      8) // Assuming each page shows 8 items
              ? () {
                  widget.onPageChanged(widget.currentPage + 1);
                }
              : null,
          child: const Column(
            children: [
              Text("Next Page"),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ],
    );
  }
}


      //this code in statelessWidget Screen to show the pagination and controlling the page number
  //               PaginationWidget(
  //           onPageChanged: onPageChanged,
  //           currentPage: _currentPage,
  //         ),

   // Function For this Screen
  //   void onPageChanged(int newPage) {
  //   setState(() {
  //     _currentPage = newPage;
  //     _updateDisplayedUsers();
  //   });
  // }