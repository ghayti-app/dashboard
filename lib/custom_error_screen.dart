import 'package:flutter/material.dart';

//then put it in main Function
customErrorScreen() {
  return ErrorWidget.builder = (details) {
    return Material(
      child: Container(
          color: Colors.black87,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                fit: BoxFit.cover, width: 150, height: 150,
                image: AssetImage(
                  'assets/images/error.png',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  details.exception.toString(),
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )),
    );
  };
}
